//
//  FeedRepository.swift
//  Domain
//
//  Created by 문종식 on 2/16/26.
//

public protocol FeedRepository {
    func getVoteFeeds(cursor: Int?, size: Int, feedStatus: String?) async throws -> VotePage
    func getMyVoteFeeds(cursor: Int?, size: Int, feedStatus: String?) async throws -> VotePage
    func postVoteFeed(info: VoteCreateInfo) async throws -> Int
    func reportVoteFeed(feedId: Int) async throws
    func deleteVoteFeed(feedId: Int) async throws
}
