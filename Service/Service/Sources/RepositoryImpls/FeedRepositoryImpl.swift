//
//  FeedRepositoryImpl.swift
//  Service
//
//  Created by 문종식 on 2/16/26.
//


import Domain

public class FeedRepositoryImpl: FeedRepository {
    private let apiClient: NetworkClientProtocol
    
    public init() {
        self.apiClient = NetworkClient.shared
    }
    
    private func request<T: Decodable>(_ endpoint: FeedEndpoint) async throws -> T {
        try await apiClient.request(endpoint)
    }
    
    private func request(_ endpoint: FeedEndpoint) async throws {
        try await apiClient.request(endpoint)
    }
    
    public func getVoteFeeds(cursor: Int?, size: Int, feedStatus: String?) async throws -> VotePage {
        let response: BaseResponse<FeedPageResponse> = try await request(.getFeeds(cursor: cursor, size: size, feedStatus: feedStatus))
        let page = response.data
        return VotePage(
            votes: page.content.map { $0.toDomain() },
            nextCursor: page.nextCursor,
            hasNext: page.hasNext
        )
    }
    
    public func getMyVoteFeeds(cursor: Int?, size: Int, feedStatus: String?) async throws -> VotePage {
        let response: BaseResponse<FeedPageResponse> = try await request(
            .getMyFeeds(cursor: cursor, size: size, feedStatus: feedStatus)
        )
        let page = response.data
        return VotePage(
            votes: page.content.map { $0.toDomain() },
            nextCursor: page.nextCursor,
            hasNext: page.hasNext
        )
    }

    public func postVoteFeed(info: VoteCreateInfo) async throws -> Int {
        let body = PostFeedRequest(
            category: info.category.rawValue,
            price: info.price,
            content: info.content,
            s3ObjectKey: info.s3ObjectKey,
            imageWidth: info.imageWidth,
            imageHeight: info.imageHeight
        )
        let response: BaseResponse<PostFeedResponse> = try await request(.postFeeds(body))
        return response.data.feedId
    }
    
    public func reportVoteFeed(feedId: Int) async throws {
        try await request(.postFeedsReport(feedId))
    }
    
    public func deleteVoteFeed(feedId: Int) async throws {
        try await request(.deleteFeeds(feedId))
    }
}
