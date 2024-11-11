//
//  NoteViewController.swift
//  Calendar
//
//  Created by Viacheslav on 29/10/2024.
//

import UIKit
import UserNotifications

class NoteViewController: UIViewController {

    @IBOutlet private weak var noteTextField: UITextField!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var noteTextView: UITextView!
    
    private var presenter: NotePresenterProtocol = NotePresenter()
    private var currentDate = Date()
    
//    @IBAction private func saveNoteTapped() {
//        presenter.saveNote(title: noteTextField.text, body: noteTextView.text, date: currentDate)
//    }
    
    @IBAction func saveNoteTapped(_ sender: Any) {
        presenter.saveNote(title: noteTextField.text, body: noteTextView.text, date: currentDate)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        dateLabel.text = " \(currentDate.month) \(currentDate.year) "
        // Do any additional setup after loading the view.
    }
    
    func update(date: Date) {
        currentDate = date
        
    }
    
    func scheduleNotifications(inSeconds seconds: TimeInterval, complition: (Bool) -> Void) {
        
        removeNotifications(withIdentifiers: ["identifier"])
        
        let date = Date(timeIntervalSinceNow: 5)
        
        let content = UNMutableNotificationContent()
        content.title = "TODAY"
        content.body = "My birthday"
        content.sound = UNNotificationSound.default
        
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        let request = UNNotificationRequest(identifier: "identifier", content: content, trigger: trigger)
        
        let center = UNUserNotificationCenter.current()
        center.add(request, withCompletionHandler: nil)
        
    }
    
    func removeNotifications( withIdentifiers idenifiers: [String]) {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: idenifiers)
    }
    
    deinit {
        removeNotifications(withIdentifiers: ["identifier"])
    }
}
