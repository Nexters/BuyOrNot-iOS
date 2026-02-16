//
//  FeedCreateInfo.swift
//  Domain
//
//  Created by 문종식 on 2/16/26.
//

public struct VoteCreateInfo {
    public let category: FeedCategory
    public let price: Int
    public let content: String
    public let s3ObjectKey: String
    public let imageWidth: Int
    public let imageHeight: Int
}
