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
            category: FeedCategory(rawValue: self.category) ?? .etc,
            yesCount: self.yesCount,
            noCount: self.noCount,
            voteStatus: VoteStatus(rawValue: self.feedStatus),
            images: self.images.map {
                VoteImage(
                    s3ObjectKey: $0.s3ObjectKey,
                    imageUrl: $0.imageUrl,
                    imageWidth: $0.imageWidth,
                    imageHeight: $0.imageHeight
                )
            },
            author: FeedAuthor(
                id: self.author.id,
                nickname: self.author.nickname,
                profileImage: self.author.profileImage
            ),
            createdAt: toDateComponents(from: self.createdAt),
            hasVoted: self.hasVoted ?? false,
            myVoteChoice: self.myVoteChoice.flatMap {
                VoteChoice(rawValue: $0)
            },
            link: self.link,
            title: self.title
        )
    }

    private func toDateComponents(from createdAt: String) -> DateComponents {
        guard let date = parseISO8601Date(createdAt) else {
            return DateComponents()
        }
        return Calendar.current.dateComponents(
            [.year, .month, .day, .hour, .minute, .second],
            from: date
        )
    }

    private func parseISO8601Date(_ value: String) -> Date? {
        if let date = getISO8601Formatter([.withInternetDateTime, .withFractionalSeconds]).date(from: value) ??
            getISO8601Formatter([.withInternetDateTime]).date(from: value) {
            return date
        }
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
        if let date = formatter.date(from: value) {
            return date
        }
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return formatter.date(from: value)
    }

    private func getISO8601Formatter(_ formatOptions: ISO8601DateFormatter.Options) -> ISO8601DateFormatter {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = formatOptions
        return formatter
    }
}
