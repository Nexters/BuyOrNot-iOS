//
//  FeedRepositoryImpl.swift
//  Service
//
//  Created by 문종식 on 2/16/26.
//


import Domain

public class FeedRepositoryImpl: FeedRepository {
    private let apiClient: NetworkClient
    
    public init() {
        self.apiClient = .shared
    }
    
    private func request<T: Decodable>(_ endpoint: FeedEndpoint) async throws -> T {
        try await apiClient.request(endpoint)
    }
    
    private func request(_ endpoint: FeedEndpoint) async throws {
        try await apiClient.request(endpoint)
    }
    
    public func getVoteFeeds() async throws -> [Vote] {
        let response: BaseResponse<[FeedsResponse]> = try await request(.getFeeds)
        return response.data.map {
            $0.toDomain()
        }
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
