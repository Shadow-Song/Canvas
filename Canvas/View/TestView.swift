//
//  TestView.swift
//  Canvas
//
//  Created by 鹿逸远 on 2024/4/25.
//

import SwiftUI

struct TestView: View {
    
    @State private var isPickerPresented = false
    @State private var fileURL: URL?
    
    @State private var message: String = ""
    @State private var showAlert: Bool = false
    
    @State private var showHandOn: Bool = false
    
    var body: some View {
        List {
            Section {
                Text(fileURL?.lastPathComponent ?? "未选择")
                
                Button("Select File") {
                    isPickerPresented = true
                }
                .sheet(isPresented: $isPickerPresented) {
                    DocumentPicker(fileURL: $fileURL)
                }
            }
            
            Section {
                Button(action: {
                    submit(fileURL: fileURL!)
                }, label: {
                    Text("Submit")
                        .bold()
                })
                .disabled(fileURL == nil)
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("提交结果"), message: Text(message), dismissButton: .default(Text("好")))
        }
        .onOpenURL(perform: { url in
            fileURL = url
            showHandOn = true
        })
        .sheet(isPresented: $showHandOn, content: {
            List {
                Section {
                    Text(fileURL?.lastPathComponent ?? "未选择")
                }
                
                Section {
                    Button(action: {
                        submit(fileURL: fileURL!)
                    }, label: {
                        Text("Submit")
                            .bold()
                    })
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("提交结果"), message: Text(message), dismissButton: .default(Text("好")))
            }
        })
    }
    
    func submit(fileURL: URL) {

        guard let session = UserDefaults.standard.string(forKey: "session") else {
            return
        }
        let course_id = "_19874_1"
        let content_id = "855349_1"
        let content = ""
        let name: String = fileURL.lastPathComponent
        
        request(
            .handOn(session: session, content_id: content_id, course_id: course_id, content: content, name: name, files: fileURL),
            success: { data in
                print("done")
                message = "已提交"
                showAlert = true
            },
            failure: { msg in
                print("error: \(msg)")
                message = msg
                showAlert = true
            }
        )

    }
}

