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
    
    func sendNotification(id: String, title: String?, body: String?, date: Date, time: Date) {
        let content = UNMutableNotificationContent()
        content.title = title ?? "event"
        content.body = body ?? ""
        content.sound = UNNotificationSound.default
        
        let calendar = Calendar.current
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        let hour = calendar.component(.hour, from: time)
        let minutes = calendar.component(.minute, from: time)
        
        var dateComponents = Calendar.current.dateComponents([.month, .day], from: date)
        dateComponents.month = month
        dateComponents.day = day
        dateComponents.hour = hour
        dateComponents.minute = minutes
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
      center.add(request) { (error) in
        print(String(describing: error?.localizedDescription))
      }
    }
    
    // Метод для удаления уведомления по ID
        func removeNotification(id: String) {
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id])
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
