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

extension DIContainer {
    func registerViewModels(_ container: Container) {
        container.register(LoginViewModel.self) { (resolver: Resolver, arg: LoginDelegate?) in
            let authRepository: AuthRepository = resolver.resolve()
            return LoginViewModel(
                authRepository: authRepository,
                delegate: arg
            )
        }
        
        container.register(AppViewModel.self) { _ in
            AppViewModel()
        }
        
        container.register(SplashViewModel.self) { (resolver: Resolver, arg: SplashDelegate?) in
            let localRepository: LocalRepository = resolver.resolve()
            return SplashViewModel(
                localRepository: localRepository,
                delegate: arg
            )
        }
    }
}
