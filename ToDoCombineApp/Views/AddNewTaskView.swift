//
//  AddNewTaskView.swift
//  ToDoCombineApp
//
//  Created by Kateryna Avramenko on 30.03.2023.
//
import SwiftUI

struct NewTaskView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var title: String = ""
    @State private var priority: TaskPriority = .medium
    @State private var dueDate: Date = Date()
    
    var onSave: ((String, TaskPriority, Date) -> Void)?
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Task Details")) {
                    TextField("Task Title", text: $title)
               
                    Picker("Priority", selection: $priority) {
                        ForEach(TaskPriority.allCases) { priority in
                            Text(priority.rawValue.capitalized).tag(priority)
                        }
                    }
                    
                    DatePicker("Due Date", selection: $dueDate, displayedComponents: [.date])
                }
            }
            .navigationTitle("New Task")
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Save") {
                    
                    if !title.isEmpty {
                        onSave?(title, priority, dueDate)
                    }
                    presentationMode.wrappedValue.dismiss()
                }
            )
        }
    }
}

