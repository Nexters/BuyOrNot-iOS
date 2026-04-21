//
//  FeedCreateInfo.swift
//  Domain
//
//  Created by 문종식 on 2/16/26.
//

public struct VoteCreateInfo {
    public struct Image {
        public let s3ObjectKey: String
        public let imageWidth: Int
        public let imageHeight: Int

        public init(
            s3ObjectKey: String,
            imageWidth: Int,
            imageHeight: Int
        ) {
            self.s3ObjectKey = s3ObjectKey
            self.imageWidth = imageWidth
            self.imageHeight = imageHeight
        }
    }

    public let category: FeedCategory
    public let price: Int
    public let link: String
    public let title: String
    public let content: String
    public let images: [Image]
    
    public init(
        category: FeedCategory,
        price: Int,
        link: String,
        title: String,
        content: String,
        images: [Image]
    ) {
        self.category = category
        self.price = price
        self.link = link
        self.title = title
        self.content = content
        self.images = images
    }
}
