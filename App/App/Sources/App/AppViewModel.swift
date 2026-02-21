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
    
    public init() {
        
    }
}

extension AppViewModel: SplashDelegate {
    func completeSplash(_ result: AuthState) {
        withAnimation(.easeInOut(duration: 0.3)) {
            switch result {
            case .member:
                launchState = .main
            case .guest:
                launchState = .login
            }
        }
    }
}

extension AppViewModel: LoginDelegate {
    func completeLogin(_ result: AuthState) {
        withAnimation(.easeInOut(duration: 0.3)) {
            launchState = .main
        }
    }
}
