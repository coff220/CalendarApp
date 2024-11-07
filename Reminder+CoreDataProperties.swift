//
//  Reminder+CoreDataProperties.swift
//  Calendar
//
//  Created by Viacheslav on 06/11/2024.
//
//

import Foundation
import CoreData

extension Reminder {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Reminder> {
        return NSFetchRequest<Reminder>(entityName: "Reminder")
    }

    @NSManaged public var body: String?
    @NSManaged public var date: Date?
    @NSManaged public var id: String?
    @NSManaged public var title: String?

}

extension Reminder: Identifiable {

}
