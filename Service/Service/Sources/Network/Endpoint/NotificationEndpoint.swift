//
//  NotificationEndpoint.swift
//  Service
//
//  Created by 이조은 on 2/25/26.
//

enum NotificationEndpoint: Endpoint {
    case getNotifications(type: String?)
    case patchNotificationRead(id: String)
    case getNotificationUnreadCount

    var path: String {
        let prefix = "/notifications"
        let path = switch self {
        case .getNotifications:
            ""
        case .patchNotificationRead(let id):
            "/\(id)/read"
        case .getNotificationUnreadCount:
            "/unread-count"
        }
        
        return version.path + prefix + path
    }

    var method: HTTPMethod {
        switch self {
        case .getNotifications, .getNotificationUnreadCount:
            .get
        case .patchNotificationRead:
            .patch
        }
    }

    var queryParameters: [String: Any]? {
        switch self {
        case .getNotifications(let type):
            var params: [String: Any] = [:]
            if let type { params["type"] = type }
            return params.isEmpty ? nil : params
        case .patchNotificationRead, .getNotificationUnreadCount:
            return nil
        }
    }
}
