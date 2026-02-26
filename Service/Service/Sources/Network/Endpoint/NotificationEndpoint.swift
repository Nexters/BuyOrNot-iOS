//
//  NotificationEndpoint.swift
//  Service
//
//  Created by 이조은 on 2/25/26.
//

enum NotificationEndpoint: Endpoint {
    case getNotifications(type: String?)

    var path: String {
        switch self {
        case .getNotifications:
            return version.path + "/notifications"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .getNotifications:
            .get
        }
    }

    var queryParameters: [String: Any]? {
        switch self {
        case .getNotifications(let type):
            var params: [String: Any] = [:]
            if let type { params["type"] = type }
            return params.isEmpty ? nil : params
        }
    }
}
