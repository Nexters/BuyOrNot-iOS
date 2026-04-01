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
        
        container.register(TokenRepository.self) { _ in
            TokenRepositoryImpl()
        }
        
        container.register(UserRepository.self) { _ in
            UserRepositoryImpl()
        }
        
        container.register(FeedRepository.self) { _ in
            FeedRepositoryImpl()
        }
        
        container.register(PendingVoteCreateInfoRepository.self) { _ in
            PendingVoteCreateInfoRepositoryImpl()
        }
        
        container.register(ReportFeedRepository.self) { _ in
            ReportFeedRepositoryImpl()
        }

        container.register(UploadsRepository.self) { _ in
            UploadsRepositoryImpl()
        }

        container.register(NotificationRepository.self) { _ in
            NotificationRepositoryImpl()
        }

        container.register(RemoteConfigRepository.self) { _ in
            RemoteConfigRepositoryImpl()
        }
    }
}
