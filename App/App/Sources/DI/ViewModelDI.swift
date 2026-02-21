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
            return LoginViewModel(
                authRepository: authRepository,
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
            let localRepository: LocalRepository = resolver.resolve()
            return AccountSettingViewModel(
                authRepository: authRepository,
                userRepository: userRepository,
                localRepository: localRepository,
                argument: argument
            )
        }
        
        container.register(DeleteAccountViewModel.self) { (resolver: Resolver, argument: DeleteAccountViewModel.Argument) in
            let userRepository: UserRepository = resolver.resolve()
            let localRepository: LocalRepository = resolver.resolve()
            return DeleteAccountViewModel(
                userRepository: userRepository,
                localRepository: localRepository,
                argument: argument
            )
        }
        
        container.register(SplashViewModel.self) { (resolver: Resolver, argument: SplashViewModel.Argument) in
            let localRepository: LocalRepository = resolver.resolve()
            return SplashViewModel(
                localRepository: localRepository,
                argument: argument
            )
        }

        container.register(HomeViewModel.self) { (resolver: Resolver, argument: HomeViewModel.Argument) in
            let repository: FeedRepository = resolver.resolve()
            return HomeViewModel(
                repository: repository,
                argument: argument
            )
        }
    }
}
