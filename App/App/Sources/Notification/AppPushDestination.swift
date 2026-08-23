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

    init?(url: URL) {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
              components.query == nil,
              components.fragment == nil,
              let feedId = Self.feedId(from: components) else {
            return nil
        }
        self = .feedDetail(feedId: feedId)
    }

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

    private static func feedId(from path: String) -> Int? {
        guard path.range(of: #"^/[0-9]+$"#, options: .regularExpression) != nil,
              let feedId = Int(String(path.dropFirst())),
              feedId > 0 else {
            return nil
        }
        return feedId
    }

    private static func feedId(from components: URLComponents) -> Int? {
        let scheme = components.scheme?.lowercased()
        let host = components.host?.lowercased()

        switch (scheme, host) {
        case ("buy-or-not", "feed"):
            return feedId(from: components.path)
        case ("https", "buy-or-not.com"):
            guard components.path.hasPrefix("/feed/") else { return nil }
            return feedId(from: String(components.path.dropFirst("/feed".count)))
        default:
            return nil
        }
    }
}
