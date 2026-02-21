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

struct FeedsResponse: Decodable {
    public let feedId: Int
    public let content: String
    public let price: Int
    public let category: String
    public let yesCount: Int
    public let noCount: Int
    public let totalCount: Int
    public let feedStatus: String
    public let s3ObjectKey: String
    public let viewUrl: String
    public let imageWidth: Int
    public let imageHeight: Int
    public let author: UserResponse
    public let createdAt: String
    public let hasVoted: Bool?
    public let myVoteChoice: String?
}
