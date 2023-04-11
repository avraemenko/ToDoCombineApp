//
//  EditTaskView.swift
//  ToDoCombineApp
//
//  Created by Kateryna Avramenko on 30.03.2023.
//

import SwiftUI

struct EditTaskView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var taskService: TaskService
    @State var task: TaskModel
    
    @State private var title: String
    @State private var priority: TaskPriority
    @State private var dueDate: Date
    
    init(taskService: TaskService, task: TaskModel) {
        self._taskService = ObservedObject(initialValue: taskService)
        self._task = State(initialValue: task)
        _title = State(initialValue: task.title)
        _priority = State(initialValue: task.priority)
        _dueDate = State(initialValue: task.dueDate)
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Title")) {
                    TextField("Task title", text: $title)
                }
                
                Section(header: Text("Priority")) {
                    Picker("Priority", selection: $priority) {
                        ForEach(TaskPriority.allCases) { priority in
                            Text(priority.rawValue.capitalized).tag(priority)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                Section(header: Text("Due Date")) {
                    DatePicker("Due Date", selection: $dueDate, displayedComponents: [.date])
                        .datePickerStyle(GraphicalDatePickerStyle())
                }
            }
            .navigationTitle("Edit Task")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveTask()
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
    
    private func saveTask() {
        var updatedTask = task
        updatedTask.title = title
        updatedTask.priority = priority
        updatedTask.dueDate = dueDate
        taskService.update(task: updatedTask)
    }
}
