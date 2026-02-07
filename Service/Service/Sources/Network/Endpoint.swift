//
//  Endpoint.swift
//  Service
//
//  Created by 이조은 on 2/7/26.
//

import Foundation

public protocol Endpoint {
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String]? { get }
    var queryParameters: [String: Any]? { get }
    var body: Encodable? { get }
}

// 기본값 제공
public extension Endpoint {
    var baseURL: String {
        return APIConstants.baseURL
    }

    var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }

    var queryParameters: [String: Any]? {
        return nil
    }

    var body: Encodable? {
        return nil
    }
}
