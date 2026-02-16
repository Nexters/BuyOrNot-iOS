//
//  FeedsResponse.swift
//  Service
//
//  Created by 문종식 on 2/16/26.
//

import Domain
import Foundation

extension FeedsResponse {
    func toDomain() -> Vote {
        Vote(
            feedId: self.feedId,
            content: self.content,
            price: self.price,
            category: FeedCategory(
                rawValue: self.category
            ),
            yesCount: self.yesCount,
            noCount: self.noCount,
            voteStatus: VoteStatus(
                rawValue: self.voteStatus
            ),
            s3ObjectKey: self.s3ObjectKey,
            imageWidth: self.imageWidth,
            imageHeight: self.imageHeight,
            author: FeedAuthor(
                id: self.author.id,
                nickname: self.author.nickname,
                profileImage: self.author.profileImage
            ),
            createdAt: Calendar.current.dateComponents(
                [.year, .month, .day, .hour, .minute, .second],
                from: self.createdAt
            )
        )
    }
}
