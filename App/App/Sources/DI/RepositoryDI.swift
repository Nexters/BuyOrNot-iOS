//
//  PlaceHolder.swift
//  Manifests
//
//  Created by 문종식 on 1/18/26.
//

import Swinject
import Domain
import Service

extension DIContainer {
    func registerRepositories(_ container: Container) {
        container.register(AuthRepository.self) { _ in
            AuthRepositoryImpl()
        }
    }
}
