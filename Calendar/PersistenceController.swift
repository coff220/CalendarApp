//
//  PersistenceController.swift
//  BroshchersCalendar
//
//  Created by Viacheslav on 21/03/2025.
//

import Foundation
import CoreData

class PersistenceController {
    static let shared = PersistenceController() // Singleton для удобного доступа

    let container: NSPersistentCloudKitContainer

    init() {
        container = NSPersistentCloudKitContainer(name: "Reminder") //  имя модели Core Data

        let storeDescription = container.persistentStoreDescriptions.first
        storeDescription?.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)
        storeDescription?.setOption(true as NSNumber, forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey)

        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Ошибка загрузки хранилища: \(error)")
            }
        }
        
        container.viewContext.automaticallyMergesChangesFromParent = true
    }

    func saveContext() {
        let context = container.viewContext
        if context.hasChanges {
            do {
                try context.save()
                print("✅ Данные сохранены в iCloud!")
            } catch {
                print("❌ Ошибка сохранения: \(error)")
            }
        }
    }
}
