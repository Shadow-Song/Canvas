//
//  ContactView.swift
//  Canvas
//
//  Created by 鹿逸远 on 2024/4/26.
//

import SwiftUI

struct ContactView: View {
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    Text("目前App仍在开发中，欢迎各位用户积极测试并提交Bug。")
                }
                
                Section {
                    HStack {
                        Text("群号：961363808")
                        Spacer()
                        Button(action: {
                            UIPasteboard.general.string = "961363808"
                        }, label: {
                            Text("复制")
                                .bold()
                        })
                    }
                }

                Section {
                    Text("感谢微信小程序“BB平台助手”提供的后端服务支持。")
                }
                Section {
                    Link(destination: URL(string:"https://beian.miit.gov.cn")!, label: {
                        Text("鲁ICP备2024093441")
                    })
                }
            }.navigationTitle("联系我们")
        }
    }
}
