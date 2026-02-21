//
//  SplashViewModel.swift
//  Splash
//
//  Created by 문종식 on 2/21/26.
//

import SwiftUI
import Domain

public final class SplashViewModel: ObservableObject {
    private let tokenRepository: TokenRepository
    private let delegate: SplashDelegate?
    
    public init(
        tokenRepository: TokenRepository,
        argument: SplashViewModel.Argument
    ) {
        self.tokenRepository = tokenRepository
        self.delegate = argument.delegate
    }
    
    func didSplashEnded() {
        let token = tokenRepository.getToken()
        let authState: AuthState = token.isEmpty ? .guest : .member
        delegate?.completeSplash(authState)
    }
}

public extension SplashViewModel {
    struct Argument {
        let delegate: SplashDelegate?
        
        public init(delegate: SplashDelegate?) {
            self.delegate = delegate
        }
    }
}
