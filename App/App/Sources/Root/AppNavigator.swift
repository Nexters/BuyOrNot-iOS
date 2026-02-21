//
//  AppNavigator.swift
//  App
//
//  Created by Codex on 2/21/26.
//

import Auth
import Vote

final class AppAuthNavigator: AuthNavigator {
    private let router: Router

    init(router: Router) {
        self.router = router
    }

    func navigateToTerms() {
        router.navigate(to: AuthDestination.terms)
    }

    func navigateToAccountSetting() {
        router.navigate(to: AuthDestination.accountSetting)
    }

    func navigateToDeleteAccount() {
        router.navigate(to: AuthDestination.deleteAccount)
    }
}

final class AppVoteNavigator: VoteNavigator {
    private let router: Router

    init(router: Router) {
        self.router = router
    }

    func navigateToNotification() {
        router.navigate(to: AppDestination.notification)
    }

    func navigateToMyPage() {
        router.navigate(to: AppDestination.myPage)
    }

    func presentCreateVote() {
        router.showCreateVote = true
    }
}
