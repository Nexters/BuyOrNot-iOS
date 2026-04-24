//
//  PendingVoteCreateInfoEntity+Extension.swift
//  Service
//
//  Created by 문종식 on 3/15/26.
//

import Domain

extension PendingVoteCreateInfoEntity {
    func toDomain() -> PendingVoteCreateInfo {
        PendingVoteCreateInfo(
            category: category.flatMap(FeedCategory.init(rawValue:)),
            linkURL: linkURL ?? "",
            title: title ?? "",
            price: price,
            content: content
        )
    }
}
