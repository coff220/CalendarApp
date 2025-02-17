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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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
    }
    
    private func showSettingsAlert() {
        let alert = UIAlertController(
            title: "Уведомления отключены",
            message: "Чтобы включить уведомления, перейдите в настройки.",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Настройки", style: .default) { _ in
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
        let doneButton = UIBarButtonItem(title: "Готово", style: .done, target: self, action: #selector(donePressed))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([space, doneButton], animated: false)
        
        timeTextField.inputAccessoryView = toolbar
        
        // Устанавливаем 10:00 по умолчанию в datePicker
                let defaultDate = Calendar.current.date(bySettingHour: 10, minute: 0, second: 0, of: Date())!
                datePicker.date = defaultDate
    }
    
//    @objc private func donePressed() {
//        let formatter = DateFormatter()
//        formatter.timeStyle = .short
//        let selectedTime = formatter.string(from: datePicker.date)
//        
//        timeTextField.text = selectedTime
//        saveTime(selectedTime) // Сохраняем в UserDefaults
//        view.endEditing(true)
//    }
//    
//    private func saveTime(_ time: String) {
//        UserDefaults.standard.set(time, forKey: "savedTime")
//            UserDefaults.standard.synchronize()
//    }
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

//   private func loadSavedTime() {
//        if let savedTime = UserDefaults.standard.string(forKey: "savedTime") {
//                    timeTextField.text = savedTime
//                } else {
//                    // Если времени нет, ставим 10:00 по умолчанию
//                    let formatter = DateFormatter()
//                    formatter.timeStyle = .short
//                    let defaultTime = formatter.string(from: datePicker.date)
//                    timeTextField.text = defaultTime
//                    saveTime(defaultTime) // Сохраняем 10:00 как дефолтное
//                }
//    }
    
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
