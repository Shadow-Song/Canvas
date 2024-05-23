//
//  API.swift
//  Canvas
//
//  Created by 鹿逸远 on 2024/1/5.
//

import Foundation
import Moya

enum BBHAPI {
    case login(param: [String: Any])
    case checkHomework(query: [String: String])
    case handOn(session: String, content_id: String, course_id: String, content: String, name: String, files: URL)
}

extension BBHAPI: TargetType {
    var baseURL: URL { return URL.init(string: "http://localhost:8000")! }
    
    var path: String {
        switch self {
        case .login:
            return "/login/"
        case .checkHomework:
            return "/api/check_homework/"
        case .handOn:
            return "/api/homework1/"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .login:
            return .post
        case .handOn:
            return .post
        case .checkHomework:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .login(let param):
            return .requestParameters(parameters: param, encoding: JSONEncoding.default)
        case .checkHomework(let query):
            return .requestParameters(parameters: query, encoding: URLEncoding.default)
        case .handOn(let session, let content_id, let course_id, let content, let name, let files):
            let fileData = MultipartFormData(provider: .file(files), name: "files")
            let _session_ = MultipartFormData(provider: .data(session.data(using: .utf8)!), name: "session")
            let _content_id_ = MultipartFormData(provider: .data(content_id.data(using: .utf8)!), name: "content_id")
            let _course_id_ = MultipartFormData(provider: .data(course_id.data(using: .utf8)!), name: "course_id")
            let _content_ = MultipartFormData(provider: .data(content.data(using: .utf8)!), name: "content")
            let _name_ = MultipartFormData(provider: .data(name.data(using: .utf8)!), name: "name")
            let _resubmit_ = MultipartFormData(provider: .data("0".data(using: .utf8)!), name: "resubmit")
            return .uploadMultipart([_content_id_, _course_id_, _session_, _name_, _resubmit_, _content_, fileData])
        }
    }
    var headers: [String : String]? {
        return [:]
    }
}

enum WlkcAPI {
    case event(session: String)
}

extension WlkcAPI: TargetType {
    var baseURL: URL { return URL.init(string: "https://wlkc.ouc.edu.cn/learn/api/public/v1")! }
    
    var method: Moya.Method { return .get }
    
    var path: String { return "/calendars/items" }
    
    var task: Task { return .requestPlain }
    
    var headers: [String : String]? {
        switch self {
        case .event(let session):
            print(session)
            return [
                "Cookie": session,
                "Content-Type": "application/json",
                "User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/107.0.0.0 Safari/537.36 MicroMessenger/6.8.0(0x16080000) NetType/WIFI MiniProgramEnv/Mac MacWechat/WMPF MacWechat/3.8.5(0x13080510)XWEB/1100",
                "xweb_xhr": "1",
                "Sec-Fetch-Site": "cross-site",
                "Sec-Fetch-Mode": "cors",
                "Sec-Fetch-Dest": "empty"
            ]
        }
    }
}
