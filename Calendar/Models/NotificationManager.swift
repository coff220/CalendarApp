//
//  NotificationManager.swift
//  Calendar
//
//  Created by Viacheslav on 05/11/2024.
//

import Foundation
import UserNotifications
import UIKit

class NotificationManager: NSObject {
    
    static let shared = NotificationManager()
    
    private let center = UNUserNotificationCenter.current()
    
    func start() {
        center.requestAuthorization(options: [.alert, .sound]) { _, _ in }
        center.delegate = self
    }
    
    func sendNonitfication(title: String?, body: String?, date: Double) {
      let content = UNMutableNotificationContent()
      content.title = title ?? "event"
      content.body = body ?? ""
      content.sound = UNNotificationSound.default
        
      let trigger = UNTimeIntervalNotificationTrigger(timeInterval: date, repeats: false)
        
      let request = UNNotificationRequest(identifier: "notification", content: content, trigger: trigger)
      center.add(request) { (error) in
        print(String(describing: error?.localizedDescription))
      }
    }
}

extension NotificationManager: UNUserNotificationCenterDelegate { // подписываемся на делегат для появлениея алерта при включеном приложении
  func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
      completionHandler([.sound, .alert]) // ф-ция вызывается когда приложение открыто
    print("ok1")
  }
  
  func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
    print("ok2") // срабатывает при нажатии на уведомление
  }
}
