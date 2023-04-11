//
//  ListContentView.swift
//  ToDoCombineApp
//
//  Created by Kateryna Avramenko on 30.03.2023.
//

import SwiftUI

struct ListContentView: View {
    
    @StateObject var service = TaskService()
    @State private var showNewTaskView = false
    @State private var searchText: String = ""
    @State private var sortOption: SortOption = .defaultSort
    
    var filteredTasks: [TaskModel] {
          let tasks = service.tasks.filter { task in
              searchText.isEmpty || task.title.localizedStandardContains(searchText)
          }
          return sortTasks(tasks: tasks)
      }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(filteredTasks) { task in
                    taskView(task: task)
                        .onTapGesture {
                            service.completeTask(task: task)
                        }
                        .swipeActions(edge: .trailing) {
                            deleteButton(task: task)
                            editButton(task: task)
                        }
                }
            }
            .searchable(text: $searchText)
            .onAppear {
                service.update()
            }
            .refreshable {
                service.update()
            }
            .navigationTitle("TODO")
            .navigationBarItems(
                            trailing: HStack {
                                menuButton
                                Button(action: addTask, label: {
                                    Image(systemName: "plus")
                                })
                            }
                        )
            .sheet(isPresented: $showNewTaskView) {
                NewTaskView { title, priority, dueDate in
                    service.add(taskTitle: title, dueDate: dueDate, priority: priority)
                }
            }
        }
    }
    
    private func taskView(task: TaskModel) -> some View {
        HStack {
            VStack(alignment: .leading) {
                Text(task.title)
                    .font(.headline)
                
                Text("Due: \(formattedDate(task.dueDate))")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            Spacer()
            Text(task.priority.rawValue.capitalized)
                .font(.subheadline)
                .foregroundColor(task.priority.priorityColor)
            
            if task.done {
                Image(systemName: "checkmark")
                    .foregroundColor(.green)
            }
        }
    }
    
    var menuButton: some View {
        Menu {
                    Button(action: { sortOption = .dueDate }) {
                        HStack {
                            Text("Due Date")
                            if sortOption == .dueDate {
                                Spacer()
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                    Button(action: { sortOption = .priority }) {
                        HStack {
                            Text("Priority")
                            if sortOption == .priority {
                                Spacer()
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                    Button(action: { sortOption = .defaultSort }) {
                        HStack {
                            Text("Default")
                            if sortOption == .defaultSort {
                                Spacer()
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                } label: {
                    Label("Sort", systemImage: "arrow.up.arrow.down")
                }
      }
    
    private func deleteButton(task: TaskModel) -> some View {
        Button("Delete") {
            service.delete(task: task)
        }
        .tint(.red)
    }
    
    private func editButton(task: TaskModel) -> some View {
        Button("Edit") {
            editTask(task: task)
        }
        .tint(.blue)
    }
    
    private func addTask() {
        showNewTaskView = true
    }
    
    func editTask(task: TaskModel) {
        let editTaskView = EditTaskView(taskService: service, task: task)
        UIApplication.shared.windows.first?.rootViewController?.present(UIHostingController(rootView: editTaskView), animated: true)
    }
    
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
    
    func sortTasks(tasks: [TaskModel]) -> [TaskModel] {
        switch sortOption {
        case .dueDate:
            return tasks.sorted(by: { $0.dueDate < $1.dueDate })
        case .priority:
            return tasks.sorted(by: { $0.priority > $1.priority })
        case .defaultSort:
            return tasks.sorted { task1, task2 in
                if task1.done != task2.done {
                    return !task1.done
                } else if task1.priority != task2.priority {
                    return task1.priority > task2.priority
                } else if task1.dueDate != task2.dueDate {
                    return task1.dueDate < task2.dueDate
                } else {
                    return task1.title.localizedStandardCompare(task2.title) == .orderedAscending
                }
            }
        }
    }



   
}
