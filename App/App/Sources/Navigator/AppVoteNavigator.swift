//
//  AppNavigator.swift
//  App
//
//  Created by Codex on 2/21/26.
//

import Vote

final class AppVoteNavigator: VoteNavigator {
    private let router: Router

    init(router: Router) {
        self.router = router
    }

    func navigateToNotification() {
        router.navigate(to: VoteDestination.notification)
    }

    func navigateToMyPage() {
        router.navigate(to: VoteDestination.myPage)
    }

    func presentCreateVote() {
        router.showCreateVote = true
    }

    func navigateToFeedDetail(feedId: Int) {
        router.navigate(to: VoteDestination.feedDetail(feedId: feedId))
    }
}
