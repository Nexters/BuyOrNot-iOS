//
//  SplashViewModel.swift
//  Splash
//
//  Created by 문종식 on 2/21/26.
//

import SwiftUI
import Domain

public final class SplashViewModel: ObservableObject {
    private let localRepository: LocalRepository
    private let delegate: SplashDelegate?
    
    public init(
        localRepository: LocalRepository,
        delegate: SplashDelegate? = nil
    ) {
        self.localRepository = localRepository
        self.delegate = delegate
    }
    
    func didSplashEnded() {
        let token = localRepository.getToken()
        let authState: AuthState = token.isEmpty ? .guest : .member
        delegate?.completeSplash(authState)
    }
}
