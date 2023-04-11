//
//  CoreDataService.swift
//  ToDoCombineApp
//
//  Created by Kateryna Avramenko on 28.03.2023.
//

import Foundation
import CoreData
import Combine

class CoreDataService {
 
    let container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
        return container
    }()

    lazy var context = container.viewContext

    var update: PassthroughSubject<Void, Never> = .init()
    var output: CurrentValueSubject<[TaskModel], Never> = .init([])
    var addValue: PassthroughSubject<TaskModel, Never> = .init()
    var updateValue: PassthroughSubject<TaskModel, Never> = .init()
    var removeValue: PassthroughSubject<TaskModel, Never> = .init()
    var completeTask: PassthroughSubject<TaskModel, Never> = .init()

    var cn = Set<AnyCancellable>()

    init() {
        update
            .compactMap { [weak self] _ in self?.fetchValues() }
            .sink { [weak self] in self?.output.send($0) }
            .store(in: &cn)


        addValue

            .filter { !$0.title.isEmpty }
            .sink { [weak self] model in
                self?.addValue(value: model)
                self?.saveContextAndPublish()
            }.store(in: &cn)

        updateValue
            .filter { !$0.title.isEmpty }
            .sink { [weak self] model in
                self?.updateValue(value: model)
                self?.saveContextAndPublish()
            }.store(in: &cn)

        removeValue
            .compactMap { [weak self] in self?.getTasks(by: $0) }
            .sink { [weak self] tasks in
                tasks.forEach { task in
                    self?.context.delete(task)
                    self?.saveContextAndPublish()
                }
            }.store(in: &cn)

        completeTask
            .sink { [weak self] task in

                self?.completeTheTask(value: task)
                self?.saveContextAndPublish()

            }.store(in: &cn)
    }

    func saveContextAndPublish() {
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch let error as NSError {
            print("Unresolved error \(error), \(error.userInfo)")
        }
        output.send(fetchValues())
    }

    private func fetchValues() -> [TaskModel] {
     
    

        var fetchedTasks: [TaskModel]!

        let request = Task.fetchRequest()

        do {
            fetchedTasks = try context
                .fetch(request)
                .compactMap{ TaskModel(from: $0) }
        } catch {
            print("UPDATE ERROR.")
        }

        return fetchedTasks
    }

    private func getTasks(by task: TaskModel) -> [Task] {
        var fetchedTasks = [Task]()

        let request = Task.fetchRequest()
        request.predicate = NSPredicate(format: "taskId = %@", task.id.uuidString)

        do {
            fetchedTasks = try context.fetch(request)
        } catch {
            print("Fetching Error.")
        }

        return fetchedTasks
    }

    private func addValue(value task: TaskModel) {
        let newTask = Task(context: context)
        newTask.setValue(task.id, forKey: #keyPath(Task.taskId))
        newTask.setValue(task.title, forKey: #keyPath(Task.title))
        newTask.setValue(false, forKey: #keyPath(Task.done))
        newTask.setValue(task.dueDate, forKey: #keyPath(Task.dueDate))
        newTask.setValue(task.priority.rawValue, forKey: #keyPath(Task.priority))
    }
  

    private func completeTheTask(value task: TaskModel) {
        let fetchedTasks = getTasks(by: task)

        guard let item = fetchedTasks.first else {
            print("UPDATE ERROR.")
            return
        }


        item.setValue(!task.done, forKeyPath: #keyPath(Task.done))

    }

    private func updateValue(value newTask: TaskModel) {
        let fetchedTasks = getTasks(by: newTask)

        guard let task = fetchedTasks.first else {
            print("UPDATE ERROR.")
            return
        }

        task.setValue(newTask.title, forKeyPath: #keyPath(Task.title))
        task.setValue(newTask.done, forKey: #keyPath(Task.done))
        task.setValue(newTask.dueDate, forKey: #keyPath(Task.dueDate))
        task.setValue(newTask.priority.rawValue, forKey: #keyPath(Task.priority))
    }
    
   
    
//    func completeTask(task: TaskModel) {
//        var updatedTask = task
//        updatedTask.done.toggle()
//        update(task: updatedTask)
//    }

}
