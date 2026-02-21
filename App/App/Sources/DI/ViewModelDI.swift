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
        
        container.register(SplashViewModel.self) { (resolver: Resolver, argument: SplashViewModel.Argument) in
            let localRepository: LocalRepository = resolver.resolve()
            return SplashViewModel(
                localRepository: localRepository,
                argument: argument
            )
        }

        container.register(HomeViewModel.self) { resolver in
            let repository: FeedRepository = resolver.resolve()
            return HomeViewModel(
                repository: repository
            )
        }
    }
}
