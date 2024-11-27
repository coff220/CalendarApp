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
    
    @IBAction func saveNoteTapped(_ sender: Any) {
        presenter.saveNote(title: noteTextField.text, body: noteTextView.text, date: currentDate)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        dateLabel.text = " \(currentDate.currentMonth) \(currentDate.year) "
        // Do any additional setup after loading the view.
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
