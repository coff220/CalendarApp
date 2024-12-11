//
//  NotePresenter.swift
//  Calendar
//
//  Created by Viacheslav on 07/11/2024.
//

import Foundation
import CoreData

protocol NotePresenterProtocol: AnyObject {
    func saveNote(title: String?, body: String?, date: Date, time: Date)
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
    
    func saveNote(title: String?, body: String?, date: Date, time: Date) {
        
        var calendar = Calendar.current
        let currentTimeZone = TimeZone.current
        calendar.timeZone = currentTimeZone // calendar.timeZone = .current
        let minutes = calendar.component(.minute, from: time)
        let hours = calendar.component(.hour, from: time)
        
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        
        guard let timeZoneHour = components.hour  else {
            print("error")
            return
        }
        
//        var timeInterval: Double = 0
//        if Int(components.hour!) <= 12 {
//            timeInterval =
//            date.timeIntervalSince1970 + Double(hours * 3600) + Double(minutes * 60) - Date().timeIntervalSince1970 - Double(timeZoneHour * 3600)
//        } else {
//            timeInterval =
//            date.timeIntervalSince1970 + Double(hours * 3600) + Double(minutes * 60) - Date().timeIntervalSince1970 - Double((timeZoneHour - 24) * 3600)
//        }
        print(" \(components)")
        
        DataBase.share.saveReminder(title: title, body: body, date: date.timeIntervalSince1970)
        NotificationManager().sendNonitfication(title: title, body: body, date: date, time: time)
    }
}
