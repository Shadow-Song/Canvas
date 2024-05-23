//
//  TodoView.swift
//  Canvas
//
//  Created by 鹿逸远 on 2024/4/25.
//

import Foundation
import SwiftyJSON
import EventKit

class TodoList: ObservableObject {
    
    @Published var todoList: [Todo] = []
    @Published var message: String = ""
    @Published var showAlert: Bool = false
    
    func getTodoList() {
        guard let session = UserDefaults.standard.string(forKey: "session") else {
            print("No Session")
            return
        }
        
        requestWlkc(.event(session: session), success: { data in
            let todoListJSON = data.arrayValue
            var todoList: [Todo] = []
            for todoJSON in todoListJSON {
                guard let todo = todoJSON.getStruct(Todo.self) else {
                    print("Convert Failed")
                    return
                }
                todoList.append(todo)
            }
            self.todoList = todoList
        }, failure: { msg in
            if msg == "session过期了" {
                Account.auto_login()
                self.message = "凭证过期了，刷新试试。"
                self.showAlert = true
            }
        })
    }
    
    func addToReminder() {
        let eventStore = EKEventStore()

        eventStore.requestAccess(to: .reminder) { (granted, error) in
            if granted {
                // 权限已授予
                self.addReminders(eventStore: eventStore)
            } else {
                // 权限被拒绝
                print("Access to reminders was denied.")
            }
        }
    }
    
    func addReminders(eventStore: EKEventStore) {
        let reminderTitles = ["提醒事项1", "提醒事项2", "提醒事项3"]
        
        for title in reminderTitles {
            let reminder = EKReminder(eventStore: eventStore)
            reminder.title = title
            reminder.calendar = eventStore.defaultCalendarForNewReminders() // 使用默认的提醒事项日历

            do {
                try eventStore.save(reminder, commit: false) // 暂时保存提醒事项但不提交
            } catch {
                print("Error saving reminder: \(error.localizedDescription)")
            }
        }

        do {
            try eventStore.commit() // 提交所有更改
            print("Reminders were successfully added.")
        } catch {
            print("Error committing reminders: \(error.localizedDescription)")
        }
    }
}

class TodoDetailList: ObservableObject {
    let todo: Todo
    @Published var todoDetail: TodoDetail? // = TodoDetail(finished: false, submit: false, content_id: "", course_id: "", description: "")
    @Published var file: Data = Data()
    @Published var fileURL: URL? = nil
    @Published var filename: String = ""
    @Published var content: String = ""
    
    @Published var showAlert: Bool = false
    @Published var message: String = ""
    
    init(todo: Todo) {
        self.todo = todo
    }
    
    func getTodoDetail() {
        guard let session = UserDefaults.standard.string(forKey: "session") else {
            print("No Session")
            return
        }
        
        let query = [
            "session": session,
            "id": todo.id
        ]
        
        request(.checkHomework(query: query), success: { data in
            if let result = data.getStruct(TodoDetail.self) {
                print("Got TodoDetail")
                self.todoDetail = result
            } else {
                print("Convert Error")
            }
        }, failure: { msg in
            if msg == "session过期了" {
                Account.auto_login()
            }
        })
    }
    
    func submit() {
        guard let session = UserDefaults.standard.string(forKey: "session") else {
            print("No Session")
            return
        }
        
        let course_id = todoDetail!.course_id
        print(course_id)
        let content_id = todoDetail!.content_id
        print(content_id)
        let name = self.fileURL!.lastPathComponent
        print(name)
        
        request(
            .handOn(session: session, content_id: content_id, course_id: course_id, content: self.content, name: name, files: self.fileURL!),
            success: { data in
                if data.boolValue {
                    self.message = "提交成功"
                    self.showAlert = true
                } else {
                    self.message = data.dictionaryValue["warning"]?.stringValue ?? ""
                    self.showAlert = true
                }
            },
            failure: { msg in
                if msg == "session过期了" {
                    Account.auto_login()
                }
            })
    }
}
