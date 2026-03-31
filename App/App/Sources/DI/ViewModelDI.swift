//
//  PlaceHolder.swift
//  Manifests
//
//  Created by 문종식 on 1/18/26.
//

import Swinject
import Auth
import Splash
import Domain
import Vote

extension DIContainer {
    func registerViewModels(_ container: Container) {
        container.register(LoginViewModel.self) { (resolver: Resolver, argument: LoginViewModel.Argument) in
            let authRepository: AuthRepository = resolver.resolve()
            let tokenRepository: TokenRepository = resolver.resolve()
            let userRepository: UserRepository = resolver.resolve()
            return LoginViewModel(
                authRepository: authRepository,
                tokenRepository: tokenRepository,
                userRepository: userRepository,
                argument: argument
            )
        }
        
        container.register(AppViewModel.self) { _ in
            AppViewModel()
        }
        
        container.register(MyPageViewModel.self) { (resolver: Resolver, argument: MyPageViewModel.Argument) in
            let userRepository: UserRepository = resolver.resolve()
            return MyPageViewModel(
                userRepository: userRepository,
                argument: argument
            )
        }
        
        container.register(AccountSettingViewModel.self) { (resolver: Resolver, argument: AccountSettingViewModel.Argument) in
            let authRepository: AuthRepository = resolver.resolve()
            let userRepository: UserRepository = resolver.resolve()
            let tokenRepository: TokenRepository = resolver.resolve()
            return AccountSettingViewModel(
                authRepository: authRepository,
                userRepository: userRepository,
                tokenRepository: tokenRepository,
                argument: argument
            )
        }
        
        container.register(DeleteAccountViewModel.self) { (resolver: Resolver, argument: DeleteAccountViewModel.Argument) in
            let userRepository: UserRepository = resolver.resolve()
            let tokenRepository: TokenRepository = resolver.resolve()
            return DeleteAccountViewModel(
                userRepository: userRepository,
                tokenRepository: tokenRepository,
                argument: argument
            )
        }
        
        container.register(BlockedAccountsViewModel.self) { (resolver: Resolver) in
            let userRepository: UserRepository = resolver.resolve()
            return BlockedAccountsViewModel(
                userRepository: userRepository
            )
        }

        container.register(SplashViewModel.self) { (resolver: Resolver, argument: SplashViewModel.Argument) in
            let tokenRepository: TokenRepository = resolver.resolve()
            let remoteConfigRepository: RemoteConfigRepository = resolver.resolve()
            return SplashViewModel(
                tokenRepository: tokenRepository,
                remoteConfigRepository: remoteConfigRepository,
                argument: argument
            )
        }

        container.register(HomeViewModel.self) { (resolver: Resolver, argument: HomeViewModel.Argument) in
            let feedRepository: FeedRepository = resolver.resolve()
            let userRepository: UserRepository = resolver.resolve()
            let reportFeedRepository: ReportFeedRepository = resolver.resolve()
            return HomeViewModel(
                feedRepository: feedRepository,
                userRepository: userRepository,
                reportFeedRepository: reportFeedRepository,
                argument: argument
            )
        }

        container.register(CreateVoteViewModel.self) { (resolver: Resolver) in
            let uploadsRepository: UploadsRepository = resolver.resolve()
            let feedRepository: FeedRepository = resolver.resolve()
            let pendingVoteCreateInfoRepository: PendingVoteCreateInfoRepository = resolver.resolve()
            return CreateVoteViewModel(
                uploadsRepository: uploadsRepository,
                feedRepository: feedRepository,
                pendingVoteCreateInfoRepository: pendingVoteCreateInfoRepository
            )
        }

        container.register(NotificationViewModel.self) { (resolver: Resolver, argument: NotificationViewModel.Argument) in
            let notificationRepository: NotificationRepository = resolver.resolve()
            return NotificationViewModel(
                notificationRepository: notificationRepository,
                argument: argument
            )
        }

        container.register(FeedDetailViewModel.self) { (resolver: Resolver) in
            let feedRepository: FeedRepository = resolver.resolve()
            let userRepository: UserRepository = resolver.resolve()
            return FeedDetailViewModel(
                feedRepository: feedRepository,
                userRepository: userRepository
            )
        }
    }
}
