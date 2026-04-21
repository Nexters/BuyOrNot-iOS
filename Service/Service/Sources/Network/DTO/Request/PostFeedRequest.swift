//
//  PostFeedRequest.swift
//  Service
//
//  Created by 문종식 on 2/16/26.
//

struct PostFeedImageRequest: Encodable {
    let s3ObjectKey: String
    let imageWidth: Int
    let imageHeight: Int
}

struct PostFeedRequest: Encodable {
    public let category: String
    public let price: Int
    public let link: String
    public let title: String
    public let content: String
    public let images: [PostFeedImageRequest]
}
