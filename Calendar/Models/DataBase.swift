//
//  DataBase.swift
//  Calendar
//
//  Created by Viacheslav on 05/11/2024.
//

import Foundation
import CoreData

class DataBase {
    
    static let share = DataBase()
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Model") // Название должно совпадать с именем .xcdatamodeld файла
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func deleteContext(_ reminder: Reminder) {
        let context = persistentContainer.viewContext
        context.delete(reminder)
        saveContext()
    }
    
    func saveReminder (title: String?, body: String?, date: Date) {
        let reminder = Reminder(context: persistentContainer.viewContext)
        reminder.title = title
        reminder.body = body
        reminder.date = date
        saveContext()
    }
}
