//
//  AppPushPendingStore.swift
//  App
//
//  Created by 문종식 on 8/11/26.
//

import Foundation

final class AppPushPendingStore {
    static let shared = AppPushPendingStore()

    private(set) var pendingDestination: AppPushDestination?

    private init() {}

    func save(userInfo: [AnyHashable: Any]) {
        pendingDestination = AppPushDestination(userInfo: userInfo)
    }

    @discardableResult
    func save(url: URL) -> Bool {
        guard let destination = AppPushDestination(url: url) else {
            return false
        }
        pendingDestination = destination
        return true
    }

    func clear() {
        pendingDestination = nil
    }
}
