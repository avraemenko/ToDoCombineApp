//
//  Task+CoreDataProperties.swift
//  ToDoCombineApp
//
//  Created by Kateryna Avramenko on 30.03.2023.
//
//

import Foundation
import CoreData


extension Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }

    @NSManaged public var title: String?
    @NSManaged public var done: Bool
    @NSManaged public var taskId: UUID?
    @NSManaged public var priority: String?
    @NSManaged public var dueDate: Date?

}

extension Task : Identifiable {

}
