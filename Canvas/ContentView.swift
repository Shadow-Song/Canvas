//
//  ContentView.swift
//  Canvas
//
//  Created by 鹿逸远 on 2024/4/22.
//

import SwiftUI

struct ContentView: View {

    var body: some View {
        TabView {
            TodoView()
                .tabItem { Label(
                    title: { Text("待办") },
                    icon: { Image(systemName: "checkmark.seal") }
                ) }
            AccountView()
                .tabItem { Label(
                    title: { Text("用户") },
                    icon: { Image(systemName: "person") }
                ) }
        }
    }
}
