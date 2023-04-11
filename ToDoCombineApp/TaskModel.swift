//
//  Task.swift
//  ToDoCombineApp
//
//  Created by Kateryna Avramenko on 28.03.2023.
//

import Foundation

struct TaskModel : Identifiable {
    var id: UUID = UUID()
    var title: String
    var done: Bool
    var dueDate: Date
    var priority: TaskPriority
    
    init(id: UUID = UUID(), title: String, done: Bool = false, dueDate: Date, priority: TaskPriority) {
        self.id = id
        self.title = title
        self.done = done
        self.dueDate = dueDate
        self.priority = priority
    }
    
    init?(title: String, done : Bool, dueDate : Date, priority : TaskPriority) {
        self.title = title
        self.done = done
        self.dueDate = dueDate
        self.priority = priority
    }
    

    init?(from task: Task) {
        guard let id = task.taskId, let title = task.title, let dueDate = task.dueDate, let priority = task.priority else { return nil }
        self.title = title
        self.done = task.done
        self.id = id
        self.dueDate = dueDate
        self.priority = TaskPriority(rawValue: priority) ?? .low
            
    }
}

   


