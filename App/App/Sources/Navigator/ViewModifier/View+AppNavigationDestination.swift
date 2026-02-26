//
//  View+AppNavigationDestination.swift
//  App
//
//  Created by Codex on 2/21/26.
//

import SwiftUI
import Vote
import Auth

extension View {
    func appNavigationDestination(
        container: DIContainer,
        authNavigator: AuthNavigator,
        voteNavigator: VoteNavigator
    ) -> some View {
        navigationDestination(for: VoteDestination.self) { destination in
            switch destination {
            case .notification:
                NotificationView(
                    viewModel: container.resolve(
                        argument: NotificationViewModel.Argument(
                            navigator: voteNavigator
                        )
                    )
                )
            case .myPage:
                MyPageView(
                    viewModel: container.resolve(
                        argument: MyPageViewModel.Argument(
                            navigator: authNavigator
                        )
                    )
                )
            case .feedDetail(let feedId):
                FeedDetailView(
                    viewModel: container.resolve(),
                    feedId: feedId
                )
            }
        }
    }
}
