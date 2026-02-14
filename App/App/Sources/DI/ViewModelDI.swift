//
//  PlaceHolder.swift
//  Manifests
//
//  Created by 문종식 on 1/18/26.
//

import Swinject
import Auth
import Domain

extension DIContainer {
    func registerViewModels(_ container: Container) {
        container.register(LoginViewModel.self) { resolver in
            let repository: AuthRepository = resolver.resolve()
            return LoginViewModel(
                repository: repository
            )
        }
    }
}
