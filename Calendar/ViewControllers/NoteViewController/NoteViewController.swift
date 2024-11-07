//
//  NoteViewController.swift
//  Calendar
//
//  Created by Viacheslav on 29/10/2024.
//

import UIKit
import UserNotifications

class NoteViewController: UIViewController {

    @IBOutlet weak var noteTextField: UITextField!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBAction func localNotification(_ sender: Any) {
        scheduleNotifications(inSeconds: 5) { (success) in
            if success {
                print("Ok")
            } else {
                printContent("failed")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        // Do any additional setup after loading the view.
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
