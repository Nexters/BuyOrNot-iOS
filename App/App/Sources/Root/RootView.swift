//
//  RootView.swift
//  App
//
//  Created by 이조은 on 2/14/26.
//

import SwiftUI
import Vote
import Auth

struct RootView: View {
    @EnvironmentObject var container: DIContainer
    @State private var router = Router()
    
    private var authNavigator: AuthNavigator {
        AppAuthNavigator(router: router)
    }
    
    private var voteNavigator: VoteNavigator {
        AppVoteNavigator(router: router)
    }

    var body: some View {
        NavigationStack(path: $router.path) {
            HomeView(
                viewModel: container.resolve(
                    argument: HomeViewModel.Argument(
                        navigator: voteNavigator
                    )
                )
            )
            .appNavigationDestination(
                container: container,
                authNavigator: authNavigator
            )
            .authNavigationDestination(
                container: container,
                authNavigator: authNavigator
            )
        }
        .sheet(isPresented: $router.showCreateVote) {
            CreateVoteView()
                .presentationDetents([.large])
                .presentationCornerRadius(18)
        }
        .environment(router)
    }
}
