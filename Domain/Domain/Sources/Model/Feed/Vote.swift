//
//  Vote.swift
//  Domain
//
//  Created by 문종식 on 2/16/26.
//

import Foundation

public struct Vote {
    public let feedId: Int
    public let content: String
    public let price: Int
    public let category: FeedCategory
    public let yesCount: Int
    public let noCount: Int
    public let voteStatus: VoteStatus
    public let s3ObjectKey: String
    public let viewUrl: String
    public let imageWidth: Int
    public let imageHeight: Int
    public let author: FeedAuthor
    public let createdAt: DateComponents
    public let hasVoted: Bool
    public let myVoteChoice: VoteChoice?

    public init(feedId: Int, content: String, price: Int, category: FeedCategory, yesCount: Int, noCount: Int, voteStatus: VoteStatus, s3ObjectKey: String, viewUrl: String, imageWidth: Int, imageHeight: Int, author: FeedAuthor, createdAt: DateComponents, hasVoted: Bool, myVoteChoice: VoteChoice?) {
        self.feedId = feedId
        self.content = content
        self.price = price
        self.category = category
        self.yesCount = yesCount
        self.noCount = noCount
        self.voteStatus = voteStatus
        self.s3ObjectKey = s3ObjectKey
        self.viewUrl = viewUrl
        self.imageWidth = imageWidth
        self.imageHeight = imageHeight
        self.author = author
        self.createdAt = createdAt
        self.hasVoted = hasVoted
        self.myVoteChoice = myVoteChoice
    }
}
