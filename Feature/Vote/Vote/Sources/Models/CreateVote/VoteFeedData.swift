//
//  VoteFeedData.swift
//  Vote
//
//  Created by 이조은 on 1/31/26.
//

import SwiftUI

/// Feed cell rendering data assembled from domain models for the Vote feature UI.
public struct VoteFeedData {
    public let id: String
    public let userId: Int
    public let userName: String
    public let userProfileImageURL: String
    public let category: String
    public let timeAgo: String
    public let title: String?
    public let content: String
    public let productImageURLs: [String]
    public let firstImageSize: CGSize?
    public let price: String
    public let link: String?
    public let voteOptions: [VoteGroup.VoteOption]
    public let selectedVoteId: Int?
    public let isPeriodDone: Bool
    public let isMine: Bool
    public let isVotingLocked: Bool
    public let canShowMenu: Bool

    public init(
        id: String,
        userId: Int = 0,
        userName: String,
        userProfileImageURL: String,
        category: String,
        timeAgo: String,
        title: String? = nil,
        content: String,
        productImageURLs: [String],
        firstImageSize: CGSize? = nil,
        price: String,
        link: String? = nil,
        voteOptions: [VoteGroup.VoteOption],
        selectedVoteId: Int? = nil,
        isPeriodDone: Bool = false,
        isMine: Bool = false,
        isVotingLocked: Bool = false,
        canShowMenu: Bool = true
    ) {
        self.id = id
        self.userId = userId
        self.userName = userName
        self.userProfileImageURL = userProfileImageURL
        self.category = category
        self.timeAgo = timeAgo
        self.title = title
        self.content = content
        self.productImageURLs = productImageURLs
        self.firstImageSize = firstImageSize
        self.price = price
        self.link = link
        self.voteOptions = voteOptions
        self.selectedVoteId = selectedVoteId
        self.isPeriodDone = isPeriodDone
        self.isMine = isMine
        self.isVotingLocked = isVotingLocked
        self.canShowMenu = canShowMenu
    }
}
