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
    @Published var appDestination: AppDestination = .splash
    
    var splashViewModelArgument: SplashViewModel.Argument {
        SplashViewModel.Argument(delegate: self)
    }
    
    var loginViewModelArgument: LoginViewModel.Argument {
        LoginViewModel.Argument(delegate: self)
    }
    
    public init() {
        
    }
}

extension AppViewModel: SplashDelegate {
    func completeSplash(_ result: AuthState) {
        withAnimation(.easeInOut(duration: 0.3)) {
            switch result {
            case .member:
                appDestination = .main
            case .guest:
                appDestination = .login
            }
        }
    }
}

extension AppViewModel: LoginDelegate {
    func completeLogin(_ result: AuthState) {
        Task { @MainActor [weak self] in
            withAnimation(.easeInOut(duration: 0.3)) {
                self?.appDestination = .main
            }
        }
    }
}
