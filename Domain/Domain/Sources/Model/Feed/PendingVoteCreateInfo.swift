//
//  PendingVoteCreateInfo.swift
//  Domain
//
//  Created by Codex on 3/15/26.
//

public struct PendingVoteCreateInfo: Equatable {
    public let category: FeedCategory?
    public let price: String
    public let content: String

    public init(
        category: FeedCategory?,
        price: String,
        content: String
    ) {
        self.category = category
        self.price = price
        self.content = content
    }
}
