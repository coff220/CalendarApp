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
        content.userInfo = ["noteID": id,
                            "title": title ?? "",
                            "body": body ?? "",
                            "date": date,
                            "time": time]
        
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
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
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
        
        let userInfo = response.notification.request.content.userInfo
        if let noteID = userInfo["noteID"] as? String,
               let title = userInfo["title"] as? String?,
               let body = userInfo["body"] as? String?,
               let date = userInfo["date"] as? Date,
               let time = userInfo["time"] as? Date {
                
            openEventDetails(id: noteID, title: title ?? "", body: body ?? "", date: date, time: time)
            }
        completionHandler()
    }
    
//    private func openEventDetails(id: String, title: String?, body: String?, date: Date, time: Date) {
//        DispatchQueue.main.async {
//            print("Available Scenes: \(UIApplication.shared.connectedScenes)")
//            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
//               let window = windowScene.windows.first,
//               let rootVC = window.rootViewController as? UITabBarController {
//                
//                let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                if let eventVC = storyboard.instantiateViewController(withIdentifier: "EventDetailsViewController") as? EventDetailsViewController {
//                    eventVC.id = id
//                    eventVC.eventTitleFromPush = title ?? ""
//                    eventVC.eventBodyFromPush = body ?? ""
//                    eventVC.eventDateFromPush = date.timeIntervalSince1970
//                    eventVC.eventTimeFromPush = time
//                    
//                    rootVC.pushViewController(eventVC, animated: true)
//                }
//            }
//        }
//    }
    
    private func openEventDetails(id: String, title: String?, body: String?, date: Date, time: Date) {
        DispatchQueue.main.async {
            print("Available Scenes: \(UIApplication.shared.connectedScenes)")
            
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = windowScene.windows.first,
               let tabBarController = window.rootViewController as? UITabBarController,
               let navController = tabBarController.selectedViewController as? UINavigationController {
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                if let eventVC = storyboard.instantiateViewController(withIdentifier: "EventDetailsViewController") as? EventDetailsViewController {
                    eventVC.id = id
                    eventVC.eventTitleFromPush = title ?? ""
                    eventVC.eventBodyFromPush = body ?? ""
                    eventVC.eventDateFromPush = date.timeIntervalSince1970
                    eventVC.eventTimeFromPush = time
                    
                    navController.pushViewController(eventVC, animated: true)
                }
            }
        }
    }

}
