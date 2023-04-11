//
//  TaskService.swift
//  ToDoCombineApp
//
//  Created by Kateryna Avramenko on 28.03.2023.
//

import Foundation
import Combine

class TaskService: ObservableObject {
    
    let model = CoreDataService()
    @Published var tasks = [TaskModel]()
    
    func update() {
        model.update.send()
    }
    
    func update(task: TaskModel) {
        model.updateValue.send(task)
    }
    
    func delete(task: TaskModel) {
        model.removeValue.send(task)
    }
    
    func add(taskTitle: String, dueDate : Date, priority : TaskPriority) {
        let task = TaskModel(title: taskTitle, dueDate: dueDate, priority: priority)
        model.addValue.send(task)
    }
    
    func completeTask(task: TaskModel) {
        model.completeTask.send(task)
    }
    
    init() {
        model.output.assign(to: &$tasks)
    }
    
    
}
