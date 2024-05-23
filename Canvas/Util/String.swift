//
//  String.swift
//  Canvas
//
//  Created by 鹿逸远 on 2024/4/25.
//

import Foundation

extension String {
    static func base64Encode(_ input: String) -> String? {
        if let inputData = input.data(using: .utf8) {
            return inputData.base64EncodedString()
        }
        return nil
    }
    
    func getDate() -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        if let date = formatter.date(from: self) {
            return date
        }
        return nil
    }
    
    static func getCnString(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "zh_CN")
        formatter.dateFormat = "yyyy年MM月dd日 EEEE HH:mm"

        let dateString = formatter.string(from: date)
        return dateString
    }
}
