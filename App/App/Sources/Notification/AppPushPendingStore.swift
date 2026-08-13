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

    func clear() {
        pendingDestination = nil
    }
}
