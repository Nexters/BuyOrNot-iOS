//
//  FeedState.swift
//  Vote
//
//  Created by 이조은 on 2/11/26.
//

// 투표 피드
enum VoteFeedState {
    case loading
    case success
    case error
}

// 내 투표
enum MyVoteState {
    case loading
    case success
    case empty
    case error
}
