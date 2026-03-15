//
//  PendingVoteCreateInfoStore.swift
//  Service
//
//  Created by Codex on 3/15/26.
//

import Domain

final class PendingVoteCreateInfoStore: EntityStore {
    let client: UserDefaultsClientProtocol
    let key: UserDefaultsKey = .pendingVoteCreateInfo

    init() {
        self.client = UserDefaultsClient()
    }

    func savePendingVoteCreateInfo(_ info: PendingVoteCreateInfo) {
        let entity = PendingVoteCreateInfoEntity(
            category: info.category?.rawValue,
            price: info.price,
            content: info.content
        )
        client.set(entity, for: key)
    }

    func getPendingVoteCreateInfo() -> PendingVoteCreateInfo? {
        let entity: PendingVoteCreateInfoEntity? = client.get(for: key)
        return entity?.toDomain()
    }

    func removePendingVoteCreateInfo() {
        client.remove(for: key)
    }
}
