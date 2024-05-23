//
//  Json.swift
//  Canvas
//
//  Created by 鹿逸远 on 2024/4/25.
//

import Foundation
import SwiftyJSON

extension JSON {
    func getStruct<T>(_ type: T.Type) -> T? where T : Decodable {
        let decoder = JSONDecoder()
        do {
            let course = try decoder.decode(type, from: self.rawData())
            return course
        } catch {
            print("Convert Failed")
            return nil
        }
    }
}
