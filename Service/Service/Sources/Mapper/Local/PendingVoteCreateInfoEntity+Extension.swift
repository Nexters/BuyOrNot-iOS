//
//  PendingVoteCreateInfoEntity+Extension.swift
//  Service
//
//  Created by Codex on 3/15/26.
//

import Domain

extension PendingVoteCreateInfoEntity {
    func toDomain() -> PendingVoteCreateInfo {
        PendingVoteCreateInfo(
            category: category.flatMap(FeedCategory.init(rawValue:)),
            price: price,
            content: content
        )
    }
}
