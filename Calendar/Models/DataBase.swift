//
//  DataBase.swift
//  Calendar
//
//  Created by Viacheslav on 05/11/2024.
//

import Foundation
import CoreData
import UIKit

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
    
    func saveReminder (title: String?, body: String?, date: Double) {
        let reminder = Reminder(context: persistentContainer.viewContext)
        reminder.title = title
        reminder.body = body
        reminder.date = date
        reminder.id = UUID().uuidString  //создаёт уникальный ID
        saveContext()
    }
    
    func getReminders(date: Date) -> Bool {
        // Получаем контекст
        let context = persistentContainer.viewContext
        
        // Имя сущности
        let entityName = "Reminder"
        
        // Создаем запрос
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
        var results = false
        fetchRequest.predicate = NSPredicate(format: "date >= %f AND date <= %f", date.intervalStartOfDay(), date.intervalEndOfDay())
        
        do {
            // Выполняем запрос
            let reminders = try context.fetch(fetchRequest)
            results = !reminders.isEmpty
        } catch let error as NSError {
            print("Ошибка получения данных: \(error), \(error.userInfo)")
        }
        return results
    }
    
    func fetchTitles() -> [String] {
        // Получаем ссылку на контекст Core Data
        let context = persistentContainer.viewContext
        
        // Создаём запрос для сущности "Reminder"
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Reminder")
        
        // Выполняем запрос
        do {
            let titles = try context.fetch(fetchRequest)
            
            // Извлекаем массив имен
            let reminderTitles = titles.compactMap { $0.value(forKey: "title") as? String }
            return reminderTitles
        } catch let error as NSError {
            print("Не удалось извлечь данные. Ошибка: \(error), \(error.userInfo)")
            return []
        }
    }
    
    func fetchBodyes() -> [String] {
        // Получаем ссылку на контекст Core Data
        let context = persistentContainer.viewContext
        
        // Создаём запрос для сущности "Reminder"
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Reminder")
        
        // Выполняем запрос
        do {
            let bodyes = try context.fetch(fetchRequest)
            
            // Извлекаем массив описаний
            let reminderBodyes = bodyes.compactMap { $0.value(forKey: "body") as? String }
            return reminderBodyes
        } catch let error as NSError {
            print("Не удалось извлечь данные. Ошибка: \(error), \(error.userInfo)")
            return []
        }
    }
    
    func fetchDate() -> [Double] {
        // Получаем ссылку на контекст Core Data
        let context = persistentContainer.viewContext
        
        // Создаём запрос для сущности "Reminder"
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Reminder")
        
        // Выполняем запрос
        do {
            let dates = try context.fetch(fetchRequest)
            
            // Извлекаем массив дат
            let reminderDates = dates.compactMap { $0.value(forKey: "date") as? Double }
            return reminderDates
        } catch let error as NSError {
            print("Не удалось извлечь данные. Ошибка: \(error), \(error.userInfo)")
            return []
        }
    }
}
