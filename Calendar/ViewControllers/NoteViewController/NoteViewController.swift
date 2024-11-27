//
//  NoteViewController.swift
//  Calendar
//
//  Created by Viacheslav on 29/10/2024.
//

import UIKit
import UserNotifications

class NoteViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {

    @IBOutlet private weak var noteTextField: UITextField!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var noteTextView: UITextView!
    
    private var presenter: NotePresenterProtocol = NotePresenter()
    private var currentDate = Date()
    
    @IBAction func saveNoteTapped(_ sender: Any) {
        let timeInterval = currentDate.timeIntervalSince1970
        presenter.saveNote(title: noteTextField.text, body: noteTextView.text, date: timeInterval)
        self.dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    func configure() {
        view.backgroundColor = .lightGray
        dateLabel.text = " \(currentDate.stringDay) \(currentDate.currentMonth) \(currentDate.year) "
        
        noteTextField.returnKeyType = .next
        noteTextView.returnKeyType = .done
        
        noteTextField.placeholder = "event"
        
        noteTextField.delegate = self
        noteTextView.delegate = self
        
        noteTextField.tag = 1
        noteTextView.tag = 2
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
        currentDate = date
    }
    
    func removeNotifications( withIdentifiers idenifiers: [String]) {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: idenifiers)
    }
    
    deinit {
        removeNotifications(withIdentifiers: ["identifier"])
    }
}
