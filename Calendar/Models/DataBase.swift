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
    
    func saveReminder (title: String?, body: String?, date: Double, type: Int64, id: String, repeats: Int64) {
        let reminder = Reminder(context: persistentContainer.viewContext)
        reminder.title = title
        reminder.body = body
        reminder.date = date
        reminder.id = id  // UUID().uuidStringсоздаёт уникальный ID
        reminder.type = type
        reminder.repeats = repeats
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
    
    func fetchReminders() -> [Reminder] {
        // Получаем ссылку на контекст Core Data
        let context = persistentContainer.viewContext
        
        // Создаём запрос для сущности "Reminder"
        let fetchRequest: NSFetchRequest<Reminder> = Reminder.fetchRequest()
        
        // Выполняем запрос
        do {
            let reminders = try context.fetch(fetchRequest)
            return reminders
        } catch let error as NSError {
            print("Не удалось извлечь данные. Ошибка: \(error), \(error.userInfo)")
            return []
        }
    }
    
    func getYearlyReminders(for date: Date, in context: NSManagedObjectContext) -> [Reminder] {
        let fetchRequest: NSFetchRequest<Reminder> = Reminder.fetchRequest()
        
        do {
            let reminders = try context.fetch(fetchRequest)
            let calendar = Calendar.current
            
            let targetMonth = calendar.component(.month, from: date)
            let targetDay = calendar.component(.day, from: date)

            // Фильтруем заметки, оставляя только те, у которых совпадает месяц и день
            let filteredReminders = reminders.filter { reminder in
                let reminderDate = Date(timeIntervalSince1970: reminder.date)
                let reminderMonth = calendar.component(.month, from: reminderDate)
                let reminderDay = calendar.component(.day, from: reminderDate)
                
                return reminderMonth == targetMonth && reminderDay == targetDay && reminder.repeats == 0
            }

            return filteredReminders
        } catch {
            print("Ошибка при загрузке заметок: \(error)")
            return []
        }
    }
    
    func fetchDayReminders(for date: Date) -> [Reminder] {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Reminder> = Reminder.fetchRequest()
        
        // Создаем начало и конец дня
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
        
        let startOfDayTimeInterval = startOfDay.timeIntervalSince1970
        let endOfDayTimeInterval = endOfDay.timeIntervalSince1970
        // Фильтр по дате
        fetchRequest.predicate = NSPredicate(format: "date >= %f AND date < %f", startOfDayTimeInterval, endOfDayTimeInterval)
        
        do {
            let reminders = try context.fetch(fetchRequest)
            let onceReminders = reminders.filter { $0.repeats == 1 }
            
            let yearlyReminders = getYearlyReminders(for: date, in: DataBase.share.persistentContainer.viewContext)
            return onceReminders + yearlyReminders
        } catch {
            print("Failed to fetch reminders: \(error)")
            return []
        }
    }
}
