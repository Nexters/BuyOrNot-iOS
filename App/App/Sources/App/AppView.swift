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
    @State private var pendingPushDestination: AppPushDestination?
    @State private var isAwaitingCreateVoteDismissForPush = false
    @State private var didResolveInitialAppDestination = false
    @State private var hasReportedAppOpenOnLaunch = false
    @State private var isReportingAppOpen = false
    
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
        AppVoteNavigator(
            router: router,
            onNavigateToLogin: {
                router.popToRoot()
                withAnimation(.easeInOut(duration: 0.3)) {
                    viewModel.appDestination = .login
                }
            }
        )
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
                    NavigationStack {
                        CreateVoteView(
                            viewModel: container.resolve()
                        )
                    }
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
                await MainActor.run {
                    processPendingPushNavigationIfPossible()
                }
            }
        }
        .onChange(of: viewModel.appDestination) { _, destination in
            guard destination != .splash else { return }

            if didResolveInitialAppDestination == false {
                didResolveInitialAppDestination = true

                if destination == .main {
                    Task {
                        let userRepository: UserRepository = container.resolve()
                        await reportAppOpenIfNeeded(userRepository: userRepository)
                    }
                }
            }

            Task { @MainActor in
                processPendingPushNavigationIfPossible()
            }
        }
        .onChange(of: router.showCreateVote) { _, isPresented in
            if isPresented == false {
                isAwaitingCreateVoteDismissForPush = false
                processPendingPushNavigationIfPossible()
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
        .onReceive(NotificationCenter.default.publisher(for: .didTapRemotePushPayload)) { notification in
            guard let userInfo = notification.userInfo,
                  let destination = AppPushDestination(userInfo: userInfo) else {
                return
            }
            pendingPushDestination = destination
            processPendingPushNavigationIfPossible()
        }
        .onReceive(NotificationCenter.default.publisher(for: .cancelCreateVoteExternalNavigation)) { _ in
            pendingPushDestination = nil
            isAwaitingCreateVoteDismissForPush = false
        }
    }

    @MainActor
    private func processPendingPushNavigationIfPossible() {
        guard let destination = pendingPushDestination else { return }
        guard viewModel.appDestination == .main else { return }

        if router.showCreateVote {
            guard isAwaitingCreateVoteDismissForPush == false else { return }
            isAwaitingCreateVoteDismissForPush = true
            NotificationCenter.default.post(
                name: .requestCreateVoteDismissForExternalNavigation,
                object: nil,
                userInfo: destination.userInfo
            )
            return
        }

        pendingPushDestination = nil
        switch destination {
        case .notification:
            router.navigate(to: VoteDestination.notification)
        case .feedDetail(let feedId):
            router.navigate(to: VoteDestination.feedDetail(feedId: feedId))
        }
    }

    @MainActor
    private func reportAppOpenIfNeeded(userRepository: UserRepository) async {
        guard hasReportedAppOpenOnLaunch == false else { return }
        guard isReportingAppOpen == false else { return }
        guard userRepository.getCachedUser() != nil else { return }

        isReportingAppOpen = true

        do {
            try await userRepository.postAppOpen()
            hasReportedAppOpenOnLaunch = true
            isReportingAppOpen = false
        } catch {
            isReportingAppOpen = false
#if DEBUG
            print("[AppView] postAppOpen error: \(error)")
#endif
        }
    }
}
