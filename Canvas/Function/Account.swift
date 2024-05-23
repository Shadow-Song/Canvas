//
//  Account.swift
//  Canvas
//
//  Created by 鹿逸远 on 2024/4/25.
//

import Foundation

class Account: ObservableObject {
    
    @Published var username: String = ""
    @Published var password: String = ""
    
    @Published var showAlert: Bool = false
    @Published var message: String = ""
    
    @Published var isLoading: Bool = false
    
    func login() {
        self.isLoading = true
        let param = [
            "username": username,
            "password": String.base64Encode(password)!
        ]
        request(.login(param: param), success: { data in
            let session = data["session"].stringValue
            UserDefaults.standard.set(self.username, forKey: "username")
            UserDefaults.standard.set(self.password, forKey: "password")
            UserDefaults.standard.set(session, forKey: "session")
            UserDefaults.standard.set(true, forKey: "login_state")
            self.username = ""
            self.password = ""
            self.isLoading = false
        }, failure: { msg in
            self.isLoading = false
            self.message = msg
            self.showAlert = true
        })
    }
    
    static func logout() {
        UserDefaults.standard.removeObject(forKey: "username")
        UserDefaults.standard.removeObject(forKey: "password")
        UserDefaults.standard.removeObject(forKey: "session")
        UserDefaults.standard.set(false, forKey: "login_state")
    }
    
    static func auto_login() {
        guard let username = UserDefaults.standard.string(forKey: "username"),
              let password = UserDefaults.standard.string(forKey: "password") else {
            
            print("No Password Info")
            Account.logout()
            return
        }
        
        let param = [
            "username": username,
            "password": String.base64Encode(password)!
        ]
        
        request(.login(param: param), success: { data in
            let session = data["session"].stringValue
            UserDefaults.standard.set(session, forKey: "session")
        }, failure: { msg in
            Account.logout()
            throw RequestError.loginError(msg: msg)
        })
    }
}
