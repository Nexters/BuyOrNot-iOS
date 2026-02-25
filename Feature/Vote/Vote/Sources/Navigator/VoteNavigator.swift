//
//  VoteNavigator.swift
//  Vote
//
//  Created by Codex on 2/21/26.
//

public protocol VoteNavigator {
    func navigateToNotification()
    func navigateToMyPage()
    func presentCreateVote()
    func navigateToFeedDetail(feedId: Int)
}
