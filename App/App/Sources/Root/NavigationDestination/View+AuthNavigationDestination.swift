//
//  View+AuthNavigationDestination.swift
//  App
//
//  Created by Codex on 2/21/26.
//

import SwiftUI
import Auth

extension View {
    func authNavigationDestination(
        container: DIContainer,
        authNavigator: AuthNavigator
    ) -> some View {
        navigationDestination(for: AuthDestination.self) { destination in
            switch destination {
            case .terms:
                PolicyView()
            case .accountSetting:
                AccountSettingView(
                    viewModel: container.resolve(
                        argument: AccountSettingViewModel.Argument(
                            navigator: authNavigator
                        )
                    )
                )
            case .deleteAccount:
                DeleteAccountView()
            }
        }
    }
}
