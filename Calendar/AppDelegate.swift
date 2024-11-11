//
//  AppDelegate.swift
//  Calendar
//
//  Created by Viacheslav on 05/10/2024.
//

import UIKit
import CoreData
@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {
    
    private let notificationManager = NotificationManager()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        notificationManager.start()
        let dataBase = DataBase.share
        
        // получить контекст
        
        var reminders = [Reminder]()
        let fetchRequest: NSFetchRequest<Reminder> = Reminder.fetchRequest()
           
           do {
               let reminder = try dataBase.persistentContainer.viewContext.fetch(fetchRequest)
                print(reminder)
               reminders = reminder
           } catch {
               print("Failed to fetch reminder: \(error)")
           }
        print(reminders)
            // удаление
        
//        dataBase.deleteContext(reminders[0])
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
}
