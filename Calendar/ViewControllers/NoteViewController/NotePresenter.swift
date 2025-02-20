//
//  NotePresenter.swift
//  Calendar
//
//  Created by Viacheslav on 07/11/2024.
//

import Foundation
import CoreData

protocol NotePresenterProtocol: AnyObject {
    func saveNote(title: String?, body: String?, date: Date, time: Date, type: Int64, id: String)
    func update(title: String?, body: String?, date: Date, time: Date, type: Int64, id: String)
}

class NotePresenter: NotePresenterProtocol {
    // для проверки crashmatic
    func crashApp() {
        fatalError("Приложение упало намеренно для тестирования.")
    }
    
    func saveNote(title: String?, body: String?, date: Date, time: Date, type: Int64, id: String) {
         crashApp()
        var calendar = Calendar.current
        let currentTimeZone = TimeZone.current
        calendar.timeZone = currentTimeZone // calendar.timeZone = .current
        let minutes = calendar.component(.minute, from: time)
        let hours = calendar.component(.hour, from: time)
        let fullInterval = date.timeIntervalSince1970 + Double(hours * 3600) + Double(minutes * 60)
        
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        
        print(" \(components)")
        
        DataBase.share.saveReminder(title: title, body: body, date: fullInterval, type: type, id: id)
        NotificationManager().sendNotification(id: id, title: title, body: body, date: date, time: time)
    }
    
    func update(title: String?, body: String?, date: Date, time: Date, type: Int64, id: String) {
        let context = DataBase.share.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Reminder> = Reminder.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        var calendar = Calendar.current
        let currentTimeZone = TimeZone.current
        calendar.timeZone = currentTimeZone // calendar.timeZone = .current
        let minutes = calendar.component(.minute, from: time)
        let hours = calendar.component(.hour, from: time)
        let fullInterval = date.timeIntervalSince1970 + Double(hours * 3600) + Double(minutes * 60)
        
        do {
            let results = try context.fetch(fetchRequest)
            if let reminder = results.first {
                reminder.title = title
                reminder.body = body
                reminder.date = fullInterval
                reminder.type = type
                try context.save()
                
                // Удаляем старое уведомление
                NotificationManager.shared.removeNotification(id: id)
                
                // Создаем новое уведомление с обновленными данными
                NotificationManager.shared.sendNotification(id: id, title: title, body: body, date: date, time: time)
                
                NotificationCenter.default.post(name: NSNotification.Name("NoteSaved"), object: nil)
            } else {
                print("Reminder with id \(id) not found")
            }
        } catch {
            print("Error updating reminder title: \(error)")
        }
    }
}
