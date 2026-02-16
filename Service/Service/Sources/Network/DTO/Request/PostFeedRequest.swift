//
//  PostFeedRequest.swift
//  Service
//
//  Created by 문종식 on 2/16/26.
//

struct PostFeedRequest: Encodable {
    public let category: String
    public let price: Int
    public let content: String
    public let s3ObjectKey: String
    public let imageWidth: Int
    public let imageHeight: Int
}
