//
//  Request.swift
//  Canvas
//
//  Created by 鹿逸远 on 2024/1/5.
//

import Foundation
import SwiftyJSON
import Moya

private var requestTimeOut: Double = 30.0

private let apiEndpointClosure = { (target: BBHAPI) -> Endpoint in
    let url = target.baseURL.absoluteString + target.path
    var endpoint = Endpoint (
        url: url,
        sampleResponseClosure: { .networkResponse(200, target.sampleData) },
        method: target.method,
        task: target.task,
        httpHeaderFields: target.headers)
    
    return endpoint
}

private let requestClosure = { (endpoint: Endpoint, done: MoyaProvider.RequestResultClosure) in
    do {
        var request = try endpoint.urlRequest()
        request.timeoutInterval = requestTimeOut

        done(.success(request))
    } catch {
        done(.failure(MoyaError.underlying(error, nil)))
    }
}

private let apiEndpointClosureWlkc = { (target: WlkcAPI) -> Endpoint in
    let url = target.baseURL.absoluteString + target.path
    var endpoint = Endpoint (
        url: url,
        sampleResponseClosure: { .networkResponse(200, target.sampleData) },
        method: target.method,
        task: target.task,
        httpHeaderFields: target.headers)
    
    return endpoint
}

let Provider = MoyaProvider<BBHAPI>(endpointClosure: apiEndpointClosure, requestClosure: requestClosure, trackInflights: false)

typealias successCallback = ((JSON) -> (Void))
typealias failureCallback = ((String) throws -> (Void))

func request(_ target: BBHAPI, success: @escaping successCallback, failure: @escaping failureCallback) {
    Provider.request(target) { (result) in
        switch result {
        case let .success(response):
            do {
                let json = try JSON(data: response.data)
                if json["code"].int == 20000 {
                    success(json["data"])
                } else {
                    print("Request Error")
                    print(json["msg"].stringValue)
                    try failure(json["msg"].stringValue)
                }
            } catch {}
        case let .failure(error):
            print(error)
            break
        }
    }
}

let ProviderWlkc = MoyaProvider<WlkcAPI>(endpointClosure: apiEndpointClosureWlkc, requestClosure: requestClosure, trackInflights: false)

func requestWlkc(_ target: WlkcAPI, success: @escaping successCallback, failure: @escaping failureCallback) {
    ProviderWlkc.request(target) { (result) in
        switch result {
        case let .success(response):
            do {
                let json = try JSON(data: response.data)
                if json["results"].exists() {
                    success(json["results"])
                } else if json["status"].intValue == 401 {
                    do {
                        try failure("Session Decrepted")
                        Account.auto_login()
                    } catch(RequestError.loginError(let msg)) {
                        print("Login Error: \(msg)")
                    } catch {
                        print(json.stringValue)
                    }
                } else {
                    print(json.stringValue)
                }
            } catch {}
        case let .failure(error):
            print(error)
            break
        }
    }
}
