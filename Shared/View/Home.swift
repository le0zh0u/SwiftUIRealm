//
//  Home.swift
//  SwiftuiRealm (iOS)
//
//  Created by 周椿杰 on 2022/5/23.
//

import SwiftUI
import RealmSwift

struct Home: View {
    
    // MARK: Fetch Data
    // Sorting by date
    @ObservedResults(TaskItem.self, sortDescriptor: SortDescriptor.init(keyPath: "taskDate", ascending: false)) var tasksFetched
    
    // Opening keyboard for newly added Task
    @State var lastAddedTaskID: String = ""
    var body: some View {
        NavigationView {
            ZStack {
                if tasksFetched.isEmpty {
                    Text("Add some new Tasks!").font(.caption)
                        .foregroundColor(.gray)
                } else {
                    List{
                        ForEach(tasksFetched){ task in
                            TaskRow(task: task, lastAddedTaskID: $lastAddedTaskID)
                            // MARK: Delete Data
                                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                    Button(role: .destructive) {
                                        $tasksFetched.remove(task)
                                    } label: {
                                        Image(systemName: "trash")
                                    }

                                }
                        }
                        
                    }
                    .listStyle(.insetGrouped)
                    .animation(.easeInOut, value: tasksFetched)
                }
            }
            .navigationTitle("Task's")
            .toolbar {
                Button {
                    // MARK: Adding Task
                    let task = TaskItem()
                    lastAddedTaskID = task.id.stringValue
                    $tasksFetched.append(task)
                } label: {
                    Image(systemName: "plus")
                }

            }
            // MARK: Observing Keyboard
            .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { _ in
                lastAddedTaskID = ""
                guard let last = tasksFetched.last else {
                    return
                }
                
                if last.taskTitle == "" {
                    $tasksFetched.remove(last)
                }
            }
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}

struct TaskRow: View {
    
    @ObservedRealmObject var task:TaskItem
    
    @Binding var lastAddedTaskID: String
    
    // MARK: Keyboard focus
    @FocusState var showkeyboard: Bool
    var body: some View{
        HStack(spacing:15){
            // MARK: Task Status Indictor Menu
            Menu {
                // MARK: Update data
                Button("Missed") {
                    $task.taskStatus.wrappedValue = .missed
                }
                Button("Completed") {
                    $task.taskStatus.wrappedValue = .completed
                }
            } label: {
                Circle()
                    .stroke(.gray)
                    .frame(width: 15, height: 15)
                    .overlay(
                        Circle().fill(task.taskStatus == .missed ? .red : (task.taskStatus == .pending) ? .yellow : .green)
                    )
            }
            
            VStack(alignment: .leading, spacing: 12) {
                // MARK: Task Title
                TextField("Refresh Kavsoft", text: $task.taskTitle)
                    .focused($showkeyboard)
                
                //MARK: Task Date
                if task.taskTitle != "" {
                    Picker(selection: .constant("")) {
                        DatePicker(selection: $task.taskDate, displayedComponents: .date) {
                            
                        }
                        .datePickerStyle(.graphical)
                        .labelsHidden()
                        .navigationTitle("Task Date")
                    } label: {
                        HStack{
                            Image(systemName: "calendar")
                            
                            Text(task.taskDate.formatted(date: .abbreviated, time: .omitted))
                            Spacer()
                        }
                    }

                }
            }
        }
        .onAppear {
            print("lastAddedTaskID: \(lastAddedTaskID)")
            print("showkeyboard1: \(showkeyboard)")
            if lastAddedTaskID == task.id.stringValue {
                showkeyboard.toggle()
                print("showkeyboard2: \(showkeyboard)")
            }
        }
    }
}
