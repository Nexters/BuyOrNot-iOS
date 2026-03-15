//
//  VoteNavigator.swift
//  Vote
//
//  Created by 문종식 on 2/21/26.
//

public protocol VoteNavigator {
    func navigateToNotification()
    func navigateToMyPage()
    func presentCreateVote()
    func navigateToFeedDetail(feedId: Int)
}
