//
//  TaskItem.swift
//  SwiftuiRealm (iOS)
//
//  Created by 周椿杰 on 2022/5/23.
//

import SwiftUI
import RealmSwift

class TaskItem: Object, Identifiable {
    @Persisted(primaryKey: true) var id: ObjectId;
    @Persisted var taskTitle: String
    @Persisted var taskDate: Date = Date()
    
    // task status
    @Persisted var taskStatus: TaskStatus = .pending
}

enum TaskStatus: String, PersistableEnum {
    case missed = "Missed"
    case completed = "Completed"
    case pending = "Pending"
}
