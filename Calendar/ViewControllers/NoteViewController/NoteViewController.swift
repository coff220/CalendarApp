//
//  NoteViewController.swift
//  Calendar
//
//  Created by Viacheslav on 29/10/2024.
//

import UIKit
import UserNotifications
import FirebaseAnalytics

class NoteViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    @IBOutlet private weak var noteTextField: UITextField!
    @IBOutlet private weak var headLabel: UILabel!
    @IBOutlet private weak var noteTextView: UITextView!
    @IBOutlet weak var yearlyTextField: UITextField!
    @IBOutlet weak var eventSegmentControl: UISegmentedControl!
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var timeTextField: UITextField!
    
    private let datePicker = UIDatePicker()
    private let timePicker = UIDatePicker()
    
    private var presenter: NotePresenterProtocol = NotePresenter()
    private var selectedDate = Date()
    
    var currentDate: Date?
    
    var completion: (() -> Void)?
    
    let options = ["Yearly", "Once"]
    let RepeatPickerView = UIPickerView()
    
    @IBAction func saveNoteTapped(_ sender: Any) {
        
        Analytics.logEvent("button_click", parameters: [
            "button_name": "example_button",
            "screen": "main_screen"
        ])
        
        presenter.saveNote(title: noteTextField.text, body: noteTextView.text, date: datePicker.date, time: timePicker.date)
//        presenter.saveNote(title: noteTextField.text, body: noteTextView.text, date: selectedDate, time: timePicker.date)
        completion?()
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .dark // Включить тёмную тему
        
        setupYearlyTextField()
        setupTimeTextField()
        setupDateTextField()
        setupNoteTextField()
        setupNoteTextView()
        setupEventSegmentControl()
        setupSaveButton()
        backgroundImage()
        
        configure()
    }
    
    func configure() {
        headLabel.text = "Add Event" // " \(selectedDate.stringDay) \(selectedDate.currentMonth) \(selectedDate.year) "
        noteTextField.returnKeyType = .next
        noteTextView.returnKeyType = .done
        
        noteTextField.delegate = self
        noteTextView.delegate = self
        
        noteTextField.tag = 1
        noteTextView.tag = 2
    }
    
    func backgroundImage() {
        // Устанавливаем картинку из assets на фон
        if let backgroundImage = UIImage(named: "eventBG") {
            let backgroundImageView = UIImageView(frame: view.bounds)
            backgroundImageView.image = backgroundImage
            backgroundImageView.contentMode = .scaleAspectFill // Опционально: чтобы изображение заполнило весь экран
            backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
            
            // Добавляем изображение как subview
            view.addSubview(backgroundImageView)
            view.sendSubviewToBack(backgroundImageView) // Отправляем изображение на задний план
            
            // Устанавливаем ограничения для масштабирования фона на весь экран
            NSLayoutConstraint.activate([
                backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
                backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ])
        }
    }
    
    func setupSaveButton() {
        saveButton.setTitle("Save", for: .normal)
        saveButton.setTitleColor(.mainDigit, for: .normal)
        saveButton.backgroundColor = .mainPurple
        saveButton.layer.cornerRadius = 12
    }
    
    func setupEventSegmentControl() {
        let imageCake = UIImage(named: "cake")
        let imageStar = UIImage(named: "star")
        let imageHeart = UIImage(named: "heart")
        let imageDanger = UIImage(named: "danger")
        eventSegmentControl.setImage(imageCake, forSegmentAt: 0)
        eventSegmentControl.setImage(imageStar, forSegmentAt: 1)
        eventSegmentControl.setImage(imageHeart, forSegmentAt: 2)
        eventSegmentControl.setImage(imageDanger, forSegmentAt: 3)
        eventSegmentControl.backgroundColor = .fills
        eventSegmentControl.selectedSegmentTintColor = .mainPurple // Устанавливаем цвет выбранного сегмента
        eventSegmentControl.layer.borderWidth = 1
        eventSegmentControl.layer.borderColor = UIColor.border.cgColor
    }
    
    func setupNoteTextField() {
        noteTextField.placeholder = "Title"
        noteTextField.backgroundColor = .fills
        noteTextField.layer.borderColor = UIColor.border.cgColor
        noteTextField.layer.borderWidth = 1
    }
    
    func setupNoteTextView() {
        noteTextView.backgroundColor = .fills
        noteTextView.layer.borderColor = UIColor.border.cgColor
        noteTextView.layer.borderWidth = 1
    }
    
    func setupTimeTextField() {
        timeTextField.backgroundColor = .fills
        timePicker.datePickerMode = .time
        timePicker.preferredDatePickerStyle = .wheels
        // Устанавливаем DatePicker как inputView для TextField
        timeTextField.inputView = timePicker
        
        // Устанавливаем время по умолчанию (10:00)
        let calendar = Calendar.current
        var components = DateComponents()
        components.hour = 10
        components.minute = 0
        if let defaultDate = calendar.date(from: components) {
            timePicker.date = defaultDate
            // Форматируем время и отображаем в TextField
            let formatter = DateFormatter()
            formatter.timeStyle = .short // Формат: "10:00 AM" или "10:00"
            formatter.dateStyle = .none
            timeTextField.text = formatter.string(from: defaultDate)
        }
        
        // Создаем Toolbar с кнопкой "Готово"
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(timeDoneTapped))
        toolbar.setItems([doneButton], animated: true)
        toolbar.isUserInteractionEnabled = true
        
        // Устанавливаем Toolbar как inputAccessoryView для TextField
        timeTextField.inputAccessoryView = toolbar
        
        // Создаем контейнер для изображения
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 20))
        let imageView = UIImageView(image: UIImage(named: "clock"))
        imageView.tintColor = .blue
        imageView.frame = CGRect(x: 5, y: 0, width: 20, height: 20)
        paddingView.addSubview(imageView)
        // Устанавливаем контейнер как rightView
        timeTextField.rightView = paddingView
        timeTextField.rightViewMode = .always
    }
    
    @objc func timeDoneTapped() {
        // Форматируем выбранное время в текст
        let formatter = DateFormatter()
        formatter.timeStyle = .short // Формат: "1:30 PM" или "13:30" (в зависимости от региона)
        formatter.dateStyle = .none // Убираем отображение даты
        
        timeTextField.text = formatter.string(from: timePicker.date)
        timeTextField.resignFirstResponder() // Закрываем DatePicker
    }
    
    func setupDateTextField() {
        dateTextField.backgroundColor = .fills
        // Устанавливаем режим для выбора только даты
        datePicker.datePickerMode = .date
        
        // Для iOS 14 и выше — настройка стиля
        if #available(iOS 14.0, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        // Создаем дату, которую нужно установить по умолчанию
        
        let dafaultDate = selectedDate
        datePicker.date = dafaultDate
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateStyle = .long
        dateTextField.text = formatter.string(from: dafaultDate)
                
        // Устанавливаем DatePicker как inputView для TextField
        dateTextField.inputView = datePicker
        
        // Создаем Toolbar с кнопкой "Готово"
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneDateTapped))
        toolbar.setItems([doneButton], animated: true)
        toolbar.isUserInteractionEnabled = true
        
        // Устанавливаем Toolbar как inputAccessoryView для TextField
        dateTextField.inputAccessoryView = toolbar
    }
    
    @objc func doneDateTapped() {
        // Форматируем выбранную дату в текст
        let formatter = DateFormatter()
        formatter.dateStyle = .long 
        formatter.timeStyle = .none
        
        dateTextField.text = formatter.string(from: datePicker.date)
        dateTextField.resignFirstResponder() // Закрываем DatePicker
        
    }
    
    // Метод делегата, вызываемый при попытке изменения текста в textView (скрываем клавиатуру при нажатии на Return)
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" { // Если пользователь нажал Return
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    // Делегат UITextField для обработки нажатия Return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextResponder = self.view.viewWithTag(textField.tag + 1) as? UITextView {
            nextResponder.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
    
    func update(date: Date) {
        selectedDate = date
    }
    
    func removeNotifications( withIdentifiers idenifiers: [String]) {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: idenifiers)
    }
    
    deinit {
        removeNotifications(withIdentifiers: ["identifier"])
    }
}

extension NoteViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func setupYearlyTextField() {
        yearlyTextField.backgroundColor = .fills
        // Настройка UIPickerView
        RepeatPickerView.delegate = self
        RepeatPickerView.dataSource = self
        
        // Связываем UIPickerView с UITextField
        yearlyTextField.inputView = RepeatPickerView
        
        // Создаем контейнер для изображения
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 20))
        let imageView = UIImageView(image: UIImage(named: "ChevronDown"))
        imageView.tintColor = .blue
        imageView.frame = CGRect(x: 5, y: 0, width: 20, height: 20)
        paddingView.addSubview(imageView)
        
        // Устанавливаем контейнер как rightView
        yearlyTextField.rightView = paddingView
        yearlyTextField.rightViewMode = .always
        
        // Добавляем кнопку "Готово" в toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneTapped))
        toolbar.setItems([doneButton], animated: true)
        toolbar.isUserInteractionEnabled = true
        yearlyTextField.inputAccessoryView = toolbar
    }
    
    // Обработка выбора
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        yearlyTextField.text = options[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return options.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return options[row]
    }
    
    @objc func doneTapped() {
        yearlyTextField.resignFirstResponder() // Закрывает UIPickerView
    }
}
