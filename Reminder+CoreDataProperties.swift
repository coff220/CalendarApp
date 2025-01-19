//
//  Reminder+CoreDataProperties.swift
//  BroshchersCalendar
//
//  Created by Viacheslav on 18/01/2025.
//
//

import Foundation
import CoreData

extension Reminder {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Reminder> {
        return NSFetchRequest<Reminder>(entityName: "Reminder")
    }

    @NSManaged public var body: String?
    @NSManaged public var date: Double
    @NSManaged public var id: String?
    @NSManaged public var title: String?
    @NSManaged public var type: Int64

}

extension Reminder: Identifiable {
}
