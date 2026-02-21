//
//  VotePage.swift
//  Domain
//
//  Created by 이조은 on 2/21/26.
//

public struct VotePage {
    public let votes: [Vote]
    public let nextCursor: Int?
    public let hasNext: Bool

    public init(votes: [Vote], nextCursor: Int?, hasNext: Bool) {
        self.votes = votes
        self.nextCursor = nextCursor
        self.hasNext = hasNext
    }
}
