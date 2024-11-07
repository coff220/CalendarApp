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
    
    let center = UNUserNotificationCenter.current()
    
    func start() {
        center.requestAuthorization(options: [.alert, .sound]) { _, _ in }
        center.delegate = self
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
