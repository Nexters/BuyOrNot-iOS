//
//  AppNavigator.swift
//  App
//
//  Created by 문종식 on 2/21/26.
//

import Vote

final class AppVoteNavigator: VoteNavigator {
    private let router: Router
    private let onNavigateToLogin: () -> Void

    init(
        router: Router,
        onNavigateToLogin: @escaping () -> Void
    ) {
        self.router = router
        self.onNavigateToLogin = onNavigateToLogin
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

    func navigateToLogin() {
        onNavigateToLogin()
    }
}
