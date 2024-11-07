//
//  DataBase.swift
//  Calendar
//
//  Created by Viacheslav on 05/11/2024.
//

import Foundation
import CoreData
// Twoja paczka nr 28607931635 zostala przygotowana przez nadawce. Przekieruj ja do automatu DHL BOX lub punktu POP na https://przekieruj.dhlparcel.pl. PIN 917760

class DataBase {
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Model") // Название должно совпадать с именем .xcdatamodeld файла
        container.loadPersistentStores { storeDescription, error in
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
}
