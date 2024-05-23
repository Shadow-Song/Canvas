//
//  CanvasApp.swift
//  Canvas
//
//  Created by 鹿逸远 on 2024/4/22.
//

import SwiftUI

@main
struct CanvasApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear(perform: {
                    Account.auto_login()
                })
        }
    }
}
