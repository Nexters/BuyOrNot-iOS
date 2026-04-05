//
//  AppUpdateStore.swift
//  Service
//
//  Created by Codex on 4/5/26.
//

import Foundation

final class AppUpdateStore: EntityStore {
    let client: UserDefaultsClientProtocol
    let key: UserDefaultsKey = .appUpdate

    init() {
        self.client = UserDefaultsClient()
    }

    func getLastSoftUpdateShownAt() -> Date? {
        let entity: AppUpdateEntity? = client.get(for: key)
        return entity?.lastSoftUpdateShownAt
    }

    func saveLastSoftUpdateShownAt(_ date: Date) {
        let entity = AppUpdateEntity(lastSoftUpdateShownAt: date)
        client.set(entity, for: key)
    }
}
