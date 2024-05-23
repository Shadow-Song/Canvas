//
//  AccountView.swift
//  Canvas
//
//  Created by 鹿逸远 on 2024/4/18.
//

import SwiftUI

struct AccountView: View {
    
    @ObservedObject private var account: Account = Account()
    @State private var username: String = ""
    @AppStorage("login_state") private var state: Bool = UserDefaults.standard.bool(forKey: "login_state")

    var body: some View {
        NavigationStack {
            if self.state {
                List {
                    Section(content: {
                        Text("01234567890"/*UserDefaults.standard.string(forKey: "username") ?? ""*/)
                            .font(.title)
                            .bold()
                    }, footer: {
                        Text("您的信息已被保存到iPhone")
                    }).padding(.vertical, 3)
                    
                    Section {
                        Button(action: {
                            Account.logout()
                            username = ""
                        }, label: {
                            Text("退出登录")
                                .bold()
                                .foregroundStyle(.red)
                        })
                    }

                    NavigationLink(destination: ContactView(), label: {
                        Label(
                            title: { Text("联系方式") },
                            icon: { Image(systemName: "text.bubble") }
                        )
                    })
//                    NavigationLink(destination: TestTodoView(), label: {
//                        Label(
//                            title: { Text("测试") },
//                            icon: { Image(systemName: "hammer") }
//                        )
//                    })
                }
                .navigationBarTitle("用户信息", displayMode: .inline)
            } else {
                List {
                    Section(content: {
                        HStack{
                            Image(systemName: "person")
                            TextField("用户名", text: $account.username)
                        }
                        HStack {
                            Image(systemName: "lock")
                            SecureField("密码", text: $account.password)
                        }
                    }, header: {
                        Text("使用信息门户的帐号密码登录")
                    }, footer: {
                        Text("您的信息将被保存到iPhone")
                    })

                    Button(action: {
                        account.login()
                        username = account.username
                    }) {
                        Text("登录").bold()
                    }
                    .alert(isPresented: $account.showAlert) {
                        Alert(title: Text("登录失败"), message: Text(account.message), dismissButton: .default(Text("好")))
                    }
                    .disabled(account.username.isEmpty || account.password.isEmpty)
                }
                .navigationTitle("登录")
            }
        }
    }
}
