//
//  SettingsViewController.swift
//  BroshchersCalendar
//
//  Created by Viacheslav on 24/12/2024.
//

import UIKit
import UserNotifications

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var notifyAtLabel: UILabel!
    @IBOutlet weak var notificationsLabel: UILabel!
    @IBOutlet weak var settingsLabel: UILabel!
    @IBOutlet weak var notificationSwitch: UISwitch!
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var timeTextField: UITextField!
    
    private var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .time // Только время
        picker.preferredDatePickerStyle = .wheels // Стиль крутящихся колес
        return picker
    }()
    
    @IBAction func notificationsSwitchChanged(_ sender: UISwitch) {
        let center = UNUserNotificationCenter.current()
        
        center.getNotificationSettings { settings in
            DispatchQueue.main.async {
                switch settings.authorizationStatus {
                case .authorized:
                    print("Разрешение уже есть, скрываем UI")
                    self.hideNotificationUI()
                    
                case .notDetermined:
                    print("Запрашиваем разрешение")
                    center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
                        DispatchQueue.main.async {
                            if let error = error {
                                print("Ошибка запроса разрешения: \(error.localizedDescription)")
                                sender.isOn = false
                            } else if granted {
                                print("Разрешение получено")
                                self.hideNotificationUI()
                            } else {
                                print("Пользователь отказался")
                                sender.isOn = false
                            }
                        }
                    }
                    
                case .denied:
                    print("Разрешение отклонено, отправляем в Настройки")
                    sender.isOn = false
                    self.showSettingsAlert()
                    
                default:
                    sender.isOn = false
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundImageSetup()
        config()
        checkNotificationPermission()
        setupDatePicker()
        loadSavedTime()
        timeTextField.backgroundColor = .clear
        timeTextField.textColor = .mainDigit
        timeTextField.font = UIFont(name: "VarelaRound-Regular", size: 17)
        
        // вызывается при возвращении из background
        NotificationCenter.default.addObserver(self, selector: #selector(appDidBecomeActive),
                                               name: UIApplication.didBecomeActiveNotification,
                                               object: nil)
    }
    
    @objc private func appDidBecomeActive() {
        print("Приложение снова активно!")
        checkNotificationPermission()
    }
    
    func backgroundImageSetup() {
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "eventBG") // Ваше изображение
        backgroundImage.contentMode = .scaleAspectFill
        view.insertSubview(backgroundImage, at: 0) // Добавляем на задний план
    }
    func config() {
        notifyAtLabel.textColor = .mainDigit
        notifyAtLabel.font = UIFont(name: "VarelaRound-Regular", size: 17)
        
        notificationsLabel.textColor = .mainDigit
        notificationsLabel.font = UIFont(name: "VarelaRound-Regular", size: 17)
        
        settingsLabel.textColor = .mainDigit
        settingsLabel.font = UIFont(name: "VarelaRound-Regular", size: 21)
    }
    
    private func checkNotificationPermission() {
        let center = UNUserNotificationCenter.current()
        center.getNotificationSettings { settings in
            DispatchQueue.main.async {
                if settings.authorizationStatus == .authorized {
                    self.hideNotificationUI()
                } else {
                    self.notificationSwitch.isOn = false
                    self.notificationSwitch.isHidden = false
                    self.notificationsLabel.isHidden = false
                }
            }
        }
    }
    
    func requestNotificationPermission() {
        let center = UNUserNotificationCenter.current()
        
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            DispatchQueue.main.async {
                if granted {
                    UIApplication.shared.registerForRemoteNotifications()
                    self.hideNotificationUI()
                } else {
                    self.notificationSwitch.isOn = false
                }
            }
        }
    }
    
    func hideNotificationUI() {
        self.notificationSwitch.isHidden = true
        self.notificationsLabel.isHidden = true
        self.lineView.isHidden = true
    }
    
    private func showSettingsAlert() {
        let alert = UIAlertController(
            title: "Notifications are disabled",
            message: "To enable notifications, go to Settings.",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Settings", style: .default) { _ in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        })
        
        if let topVC = UIApplication.shared.windows.first?.rootViewController {
            topVC.present(alert, animated: true)
        }
    }
}

// настройка timeTextField
extension SettingsViewController {
    private func setupDatePicker() {
        // Назначаем `datePicker` как inputView для `timeTextField`
        timeTextField.inputView = datePicker
        
        // Добавляем Toolbar с кнопками "Готово"
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        toolbar.tintColor = .mainPurple
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(donePressed))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([space, doneButton], animated: false)
        
        timeTextField.inputAccessoryView = toolbar
        
        // Устанавливаем 10:00 по умолчанию в datePicker
        let defaultDate = Calendar.current.date(bySettingHour: 10, minute: 0, second: 0, of: Date())!
        datePicker.date = defaultDate
    }
    
    private func saveTime(_ time: Date) {
        UserDefaults.standard.set(time.timeIntervalSince1970, forKey: "savedTime")
        UserDefaults.standard.synchronize()
    }
    
    
    @objc private func donePressed() {
        let selectedTime = datePicker.date
        timeTextField.text = formatTime(selectedTime) // Отобразить в TextField
        saveTime(selectedTime) // Сохранить в UserDefaults
        
        // Скрываем клавиатуру (и DatePicker)
        timeTextField.resignFirstResponder()
    }
    
    
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.locale = Locale.current
        return formatter.string(from: date)
    }
    
    private func loadSavedTime() {
        if let savedTime = UserDefaults.standard.value(forKey: "savedTime") as? TimeInterval {
            let date = Date(timeIntervalSince1970: savedTime)
            timeTextField.text = formatTime(date)
        } else {
            // Если времени нет, ставим 10:00 по умолчанию
            let calendar = Calendar.current
            var defaultComponents = DateComponents()
            defaultComponents.hour = 10
            defaultComponents.minute = 0
            
            if let defaultDate = calendar.date(from: defaultComponents) {
                timeTextField.text = formatTime(defaultDate)
                saveTime(defaultDate) // Сохраняем 10:00
            }
        }
    }
    
}
