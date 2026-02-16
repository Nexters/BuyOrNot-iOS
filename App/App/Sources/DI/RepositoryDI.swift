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
        
        container.register(LocalRepository.self) { _ in
            LocalRepositoryImpl()
        }
        
        container.register(UserRepository.self) { _ in
            UserRepositoryImpl()
        }
        
        container.register(FeedRepository.self) { _ in
            FeedRepositoryImpl()
        }

        container.register(UploadsRepository.self) { _ in
            UploadsRepositoryImpl()
        }
    }
}
