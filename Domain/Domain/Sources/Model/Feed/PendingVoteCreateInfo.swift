//
//  PendingVoteCreateInfo.swift
//  Domain
//
//  Created by 문종식 on 3/15/26.
//

public struct PendingVoteCreateInfo: Equatable {
    public let category: FeedCategory?
    public let linkURL: String
    public let price: String
    public let content: String

    public init(
        category: FeedCategory?,
        linkURL: String = "",
        price: String,
        content: String
    ) {
        self.category = category
        self.linkURL = linkURL
        self.price = price
        self.content = content
    }
}
