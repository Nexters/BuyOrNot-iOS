//
//  AppView.swift
//  App
//
//  Created by 이조은 on 2/14/26.
//

import SwiftUI
import Vote
import Auth
import Splash
import Domain
import Core

struct AppView: View {
    @EnvironmentObject var container: DIContainer
    @Environment(\.scenePhase) private var scenePhase
    @StateObject var viewModel: AppViewModel
    @State private var router = Router()
    
    private var authNavigator: AuthNavigator {
        AppAuthNavigator(
            router: router,
            onNavigateToLogin: {
                router.popToRoot()
                withAnimation(.easeInOut(duration: 0.3)) {
                    viewModel.appDestination = .login
                }
            }
        )
    }
    
    private var voteNavigator: VoteNavigator {
        AppVoteNavigator(router: router)
    }
    
    init(viewModel: AppViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        Group {
            switch viewModel.appDestination {
            case .splash:
                SplashView(
                    viewModel: container.resolve(
                        argument: viewModel.splashViewModelArgument
                    )
                )
            case .login:
                LoginView(
                    viewModel: container.resolve(
                        argument: viewModel.loginViewModelArgument
                    )
                )
            case .main:
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
                        authNavigator: authNavigator,
                        voteNavigator: voteNavigator
                    )
                    .authNavigationDestination(
                        container: container,
                        authNavigator: authNavigator
                    )
                }
                .sheet(isPresented: $router.showCreateVote) {
                    CreateVoteView(
                        viewModel: container.resolve()
                    )
                        .presentationDetents([.large])
                        .presentationCornerRadius(18)
                }
                .environment(router)
            }
        }
        .task {
            await PushNotificationService.shared.requestAuthorizationIfNeeded()
        }
        .onChange(of: scenePhase) { _, phase in
            guard phase == .active else { return }
            Task {
                let userRepository: UserRepository = container.resolve()
                await PushNotificationService.shared.syncFCMTokenIfPossible(
                    userRepository: userRepository
                )
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .authSessionDidExpire)) { _ in
            Task { @MainActor in
                router.popToRoot()
                withAnimation(.easeInOut(duration: 0.3)) {
                    viewModel.appDestination = .login
                }
            }
        }
    }
}
