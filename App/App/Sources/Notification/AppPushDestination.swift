//
//  AppPushDestination.swift
//  App
//
//  Created by 문종식 on 7/31/26.
//

import Foundation

enum AppPushDestination {
    case notification
    case feedDetail(feedId: Int)

    init?(userInfo: [AnyHashable: Any]) {
        if let feedId = Self.feedId(from: userInfo) {
            self = .feedDetail(feedId: feedId)
            return
        }

        guard let screen = userInfo["screen"] as? String, screen == "NOTIFICATIONS" else {
            return nil
        }
        self = .notification
    }

    var userInfo: [AnyHashable: Any] {
        switch self {
        case .notification:
            ["screen": "NOTIFICATIONS"]
        case .feedDetail(let feedId):
            [
                "screen": "NOTIFICATIONS",
                "feedId": String(feedId)
            ]
        }
    }

    private static func feedId(from userInfo: [AnyHashable: Any]) -> Int? {
        if let feedId = userInfo["feedId"] as? Int {
            return feedId
        }
        if let feedId = userInfo["feedId"] as? String {
            return Int(feedId)
        }
        return nil
    }
}
