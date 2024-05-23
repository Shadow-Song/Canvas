//
//  Error.swift
//  Canvas
//
//  Created by 鹿逸远 on 2024/4/26.
//

import Foundation

enum RequestError: Error {
    case noSessionError
    case noPasswordError
    case loginError(msg: String)
    case decrepSessionError
}
