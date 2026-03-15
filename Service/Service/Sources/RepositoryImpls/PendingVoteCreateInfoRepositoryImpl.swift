//
//  PendingVoteCreateInfoRepositoryImpl.swift
//  Service
//
//  Created by 문종식 on 3/15/26.
//

import Domain

public final class PendingVoteCreateInfoRepositoryImpl: PendingVoteCreateInfoRepository {
    private let store: PendingVoteCreateInfoStore

    public init() {
        self.store = PendingVoteCreateInfoStore()
    }

    public func savePendingVoteCreateInfo(_ info: PendingVoteCreateInfo) {
        store.savePendingVoteCreateInfo(info)
    }

    public func getPendingVoteCreateInfo() -> PendingVoteCreateInfo? {
        store.getPendingVoteCreateInfo()
    }

    public func removePendingVoteCreateInfo() {
        store.removePendingVoteCreateInfo()
    }
}
