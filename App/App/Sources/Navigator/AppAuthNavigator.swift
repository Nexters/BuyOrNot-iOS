//
//  AppNavigator.swift
//  App
//
//  Created by Codex on 2/21/26.
//

import Auth

final class AppAuthNavigator: AuthNavigator {
    private let router: Router
    private let onNavigateToLogin: () -> Void

    init(
        router: Router,
        onNavigateToLogin: @escaping () -> Void
    ) {
        self.router = router
        self.onNavigateToLogin = onNavigateToLogin
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
    
    func navigateToLogin() {
        onNavigateToLogin()
    }
}
