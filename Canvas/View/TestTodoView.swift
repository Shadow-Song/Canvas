//
//  TestTodoView.swift
//  Canvas
//
//  Created by 鹿逸远 on 2024/4/29.
//

import SwiftUI

struct TestTodoView: View {
    
    let todo: Todo = Todo(
        id: "_169088_1",
        type: "GradebookColumn",
        calendarId: "_27375_1",
        calendarName: "数据结构与算法",
        title: "第九周实验",
        start: "2024-05-08T15:59:00.000Z",
        end: "2024-05-08T15:59:00.000Z",
        color: "#4a831c",
        disableResizing: true,
        dynamicCalendarItemProps: DynamicCalendarItemProps(
            attemptable: true,
            categoryId: "_249051_1",
            dateRangeLimited: false,
            eventType: "作业",
            gradable: false
        )
    )
    var body: some View {
        TodoDetailView(_todo_: todo)
    }
}
