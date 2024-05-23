//
//  Todo.swift
//  Canvas
//
//  Created by 鹿逸远 on 2024/4/25.
//

import Foundation

struct Todo: Codable {
    var id: String
    var type: String
    var calendarId: String
    var calendarName: String
    var title: String
    var start: String
    var end: String
    var modified: String?
    var color: String
    var disableResizing: Bool
    var createdByUserId: String?
    var dynamicCalendarItemProps: DynamicCalendarItemProps
}

struct DynamicCalendarItemProps: Codable {
    var attemptable: Bool
    var categoryId: String
    var dateRangeLimited: Bool
    var eventType: String
    var gradable: Bool
}

struct TodoDetail: Codable {
    var finished: Bool
    var submit: Bool
    var content_id: String
    var course_id: String
    var description: String
}
