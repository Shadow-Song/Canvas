//
//  TodoView.swift
//  Canvas
//
//  Created by 鹿逸远 on 2024/4/22.
//

import SwiftUI

struct TodoView: View {
    
    @ObservedObject var todoList: TodoList = TodoList()
    @AppStorage("login_state") private var state = UserDefaults.standard.bool(forKey: "login_state")
    @State private var showHandon: Bool = false
    @State private var handonURL: URL? = nil
    
    var body: some View {
        NavigationStack {
            if !state {
                VStack {
                    Image(systemName: "person")
                        .font(.largeTitle)
                    Text("未登录")
                        .font(.title3)
                        .bold()
                        .padding()
                }
                .foregroundStyle(.gray)
            } else if todoList.todoList.isEmpty {
                VStack {
                    Image(systemName: "text.badge.checkmark")
                        .font(.largeTitle)
                    Text("待办清单为空，去睡觉吧！")
                        .font(.title3)
                        .bold()
                        .padding()
                }
                .foregroundStyle(.gray)
                
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing, content: {
                        Button(action: todoList.getTodoList, label: {
                            Image(systemName: "arrow.clockwise")
                        })
                    })
                }
                .navigationBarTitle("待办", displayMode: .inline)
            } else {
                List(todoList.todoList, id: \.self.id) { todo in
                    NavigationLink(destination: {
                        TodoDetailView(_todo_: todo)
                    }, label: {
                        VStack(alignment: .leading, content: {
                            Text(todo.title)
                                .bold()
                                .font(.title2)
                            Text(todo.calendarName)
                            Text("截止时间：\(String.getCnString(todo.end.getDate()!))")
                                .font(.caption)
                                .foregroundStyle(.gray)
                        })
                    })
                }
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing, content: {
                        Button(action: todoList.getTodoList, label: {
                            Image(systemName: "arrow.clockwise")
                        })
                        .disabled(!state)
                    })
                }
                .navigationBarTitle("待办", displayMode: .inline)
            }
            
        }
        .onAppear(perform: {
            todoList.getTodoList()
        })
        .alert(isPresented: $todoList.showAlert) {
            Alert(title: Text("获取失败"), message: Text(todoList.message), dismissButton: .default(Text("好")))
        }
        .onOpenURL(perform: { url in
            if state {
                self.todoList.getTodoList()
                showHandon = true
                handonURL = url
            }
        })
        .sheet(isPresented: $showHandon, content: {
            NavigationStack {
                if todoList.todoList.isEmpty {
                    VStack {
                        Image(systemName: "text.badge.checkmark")
                            .font(.largeTitle)
                        Text("待办清单为空，去睡觉吧！")
                            .font(.title3)
                            .bold()
                            .padding()
                    }
                    .foregroundStyle(.gray)
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing, content: {
                            Button(action: todoList.getTodoList, label: {
                                Image(systemName: "arrow.clockwise")
                            })
                            .disabled(!state)
                        })
                    }
                } else if handonURL != nil {
                    List(todoList.todoList, id: \.self.id) { todo in
                        NavigationLink(destination: {
                            HandOnDetailView(_todo_: todo, _fileURL_: handonURL!)
                        }, label: {
                            VStack(alignment: .leading, content: {
                                Text(todo.title)
                                    .bold()
                                    .font(.title2)
                                Text(todo.calendarName)
                                Text("截止时间：\(String.getCnString(todo.end.getDate()!))")
                                    .font(.caption)
                                    .foregroundStyle(.gray)
                            })
                        })
                    }
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing, content: {
                            Button(action: todoList.getTodoList, label: {
                                Image(systemName: "arrow.clockwise")
                            })
                            .disabled(!state)
                        })
                    }
                    .navigationBarTitle("提交作业", displayMode: .inline)
                }
            }
        })
    }
    
}

struct HandOnDetailView: View {
    let todo: Todo
    @ObservedObject var todoDetailList: TodoDetailList
    @State private var fileName: String
    let fileURL: URL
    
    init(_todo_: Todo, _fileURL_: URL) {
        todo = _todo_
        todoDetailList = TodoDetailList(todo: _todo_)
        fileURL = _fileURL_
        fileName = _fileURL_.lastPathComponent
    }
    
    var body: some View {
        List {
            Section {
                HStack {
                    Text("课程")
                        .bold()
                    Spacer()
                    Text(todo.calendarName)
                }
                
                HStack {
                    Text("作业名称")
                        .bold()
                    Spacer()
                    Text(todo.title)
                }
                
                HStack {
                    Text("截止时间")
                        .bold()
                    Spacer()
                    Text("\(String.getCnString(todo.end.getDate()!))")
                        .multilineTextAlignment(.trailing)
                }
                
                HStack {
                    Text("提交状态")
                        .bold()
                    Spacer()
                    Text("\(todoDetailList.todoDetail?.submit ?? false ? "已" : "未")提交")
                }
                
            }
            
            HStack {
                Text("文件").bold()
                Spacer()
                Text(fileName)
            }
            
            Section {
                Button(action: {
                    todoDetailList.fileURL = fileURL
                    todoDetailList.submit()
                }, label: {
                    Text("提交")
                        .bold()
                })
            }
        }
        .alert(isPresented: $todoDetailList.showAlert) {
            Alert(title: Text("提交结果"), message: Text(todoDetailList.message), dismissButton: .default(Text("好")))
        }
        
    }
}

struct TodoDetailView: View {
    
    let todo: Todo
    @ObservedObject var todoDetailList: TodoDetailList
    @State private var fileName: String? = nil
    @State private var isPickerPresented = false
    
    init(_todo_: Todo) {
        todo = _todo_
        todoDetailList = TodoDetailList(todo: _todo_)
    }
    
    var body: some View {
        List {
            Section {
                HStack {
                    Text("课程")
                        .bold()
                    Spacer()
                    Text(todo.calendarName)
                }
                
                HStack {
                    Text("作业名称")
                        .bold()
                    Spacer()
                    Text(todo.title)
                }
                
                HStack {
                    Text("截止时间")
                        .bold()
                    Spacer()
                    Text("\(String.getCnString(todo.end.getDate()!))")
                        .multilineTextAlignment(.trailing)
                }
                
                HStack {
                    Text("提交状态")
                        .bold()
                    Spacer()
                    Text("\((todoDetailList.todoDetail?.submit ?? false ? "已" : "未"))提交")
                }
                
            }
            
            Section {
                HStack {
                    Text("文件").bold()
                    Spacer()
                    Text("\(todoDetailList.fileURL?.lastPathComponent ?? "未选取")")
                }
                
                Button(action: {
                    isPickerPresented = true
                }, label: {
                    Text("选取文件")
                })
            }
            
            Section {
                Button(action: {
                    todoDetailList.submit()
                }, label: {
                    Text("提交")
                        .bold()
                }).disabled(todoDetailList.fileURL == nil || todoDetailList.todoDetail == nil)
            }
        }
        .onAppear(perform: {
            todoDetailList.getTodoDetail()
        })
        .sheet(isPresented: $isPickerPresented, content: {
            DocumentPicker(fileURL: $todoDetailList.fileURL)
        })
        .alert(isPresented: $todoDetailList.showAlert) {
            Alert(title: Text("提交结果"), message: Text(todoDetailList.message), dismissButton: .default(Text("好")))
        }

    }
}
