//
//  AppViewModel.swift
//  App
//
//  Created by 문종식 on 2/15/26.
//

import SwiftUI
import Domain
import Splash
import Auth

final class AppViewModel: ObservableObject {
    @Published var launchState: LaunchState = .splash
    
    private let authRepository: AuthRepository
    private let localRepository: LocalRepository
    
    public init(
        authRepository: AuthRepository,
        localRepository: LocalRepository
    ) {
        self.authRepository = authRepository
        self.localRepository = localRepository
    }
    
    func onAppear() {
        let token = localRepository.getToken()
        // TODO
    }
}

extension AppViewModel: SplashDelegate {
    func completeSplash() {
        // TODO
    }
}

extension AppViewModel: LoginDelegate {
    func completeLogin(_ result: LoginResult) {
        // TODO
    }
}
