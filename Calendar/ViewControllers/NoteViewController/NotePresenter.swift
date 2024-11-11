//
//  NotePresenter.swift
//  Calendar
//
//  Created by Viacheslav on 07/11/2024.
//

import Foundation
import CoreData

protocol NotePresenterProtocol: AnyObject {
    func saveNote(title: String?, body: String?, date: Date)
}

class NotePresenter: NotePresenterProtocol {
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    //        let reminder = Reminder(context: dataBase.persistentContainer.viewContext)
    //        reminder.id = "123"
    //        reminder.body = "порор"
    //        reminder.date = Date()
    //        reminder.title = " N1 "
            
            // Сохраните контекст, чтобы зафиксировать изменения
    //        do {
    //            try dataBase.persistentContainer.viewContext.save()
    //            print("Объект сохранен успешно!")
    //        } catch {
    //            print("Ошибка сохранения: \(error)")
    //        }
    
    func saveNote(title: String?, body: String?, date: Date) {
        DataBase.share.saveReminder(title: title, body: body, date: date)
        // сделать пуш
    }
    
}

// @IBAction func notification(_ sender: Any) {
//    scheduleNotifications(inSeconds: 5) { (success) in
//        if success {
//            print("Ok")
//        } else {
//            printContent("failed")
//        }
//    }
// }
