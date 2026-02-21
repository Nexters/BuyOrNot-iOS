//
//  VoteResult.swift
//  Domain
//
//  Created by 이조은 on 2/21/26.
//

public struct VoteResult {
    public let feedId: Int
    public let choice: VoteChoice
    public let yesCount: Int
    public let noCount: Int
    public let totalCount: Int

    public init(feedId: Int, choice: VoteChoice, yesCount: Int, noCount: Int, totalCount: Int) {
        self.feedId = feedId
        self.choice = choice
        self.yesCount = yesCount
        self.noCount = noCount
        self.totalCount = totalCount
    }
}
