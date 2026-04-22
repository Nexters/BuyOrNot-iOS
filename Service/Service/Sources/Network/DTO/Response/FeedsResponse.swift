//
//  FeedsResponse.swift
//  Service
//
//  Created by 문종식 on 2/16/26.
//

import Foundation

struct FeedPageResponse: Decodable {
    let content: [FeedsResponse]
    let nextCursor: Int?
    let hasNext: Bool
}

struct FeedImageResponse: Decodable {
    let s3ObjectKey: String
    let imageUrl: String
    let imageWidth: Int
    let imageHeight: Int
}

struct FeedsResponse: Decodable {
    public let feedId: Int
    public let content: String
    public let price: Int
    public let category: String
    public let yesCount: Int
    public let noCount: Int
    public let totalCount: Int
    public let feedStatus: String
    public let images: [FeedImageResponse]
    public let author: UserResponse
    public let createdAt: String
    public let hasVoted: Bool?
    public let myVoteChoice: String?
    public let link: String?
    public let title: String?
}
