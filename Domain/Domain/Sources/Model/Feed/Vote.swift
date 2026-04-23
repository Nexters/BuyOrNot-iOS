//
//  Vote.swift
//  Domain
//
//  Created by 문종식 on 2/16/26.
//

import Foundation

public struct VoteImage {
    public let s3ObjectKey: String
    public let imageUrl: String
    public let imageWidth: Int
    public let imageHeight: Int

    public init(s3ObjectKey: String, imageUrl: String, imageWidth: Int, imageHeight: Int) {
        self.s3ObjectKey = s3ObjectKey
        self.imageUrl = imageUrl
        self.imageWidth = imageWidth
        self.imageHeight = imageHeight
    }
}

public struct Vote {
    public let feedId: Int
    public let content: String
    public let price: Int
    public let category: FeedCategory
    public let yesCount: Int
    public let noCount: Int
    public let voteStatus: VoteStatus
    public let images: [VoteImage]
    public let author: FeedAuthor
    public let createdAt: DateComponents
    public let hasVoted: Bool
    public let myVoteChoice: VoteChoice?
    public let link: String?
    public let title: String?

    public init(
        feedId: Int,
        content: String,
        price: Int,
        category: FeedCategory,
        yesCount: Int,
        noCount: Int,
        voteStatus: VoteStatus,
        images: [VoteImage],
        author: FeedAuthor,
        createdAt: DateComponents,
        hasVoted: Bool,
        myVoteChoice: VoteChoice?,
        link: String?,
        title: String?
    ) {
        self.feedId = feedId
        self.content = content
        self.price = price
        self.category = category
        self.yesCount = yesCount
        self.noCount = noCount
        self.voteStatus = voteStatus
        self.images = images
        self.author = author
        self.createdAt = createdAt
        self.hasVoted = hasVoted
        self.myVoteChoice = myVoteChoice
        self.link = link
        self.title = title
    }
}
