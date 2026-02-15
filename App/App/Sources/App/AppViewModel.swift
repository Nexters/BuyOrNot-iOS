//
//  AppViewModel.swift
//  App
//
//  Created by 문종식 on 2/15/26.
//

import SwiftUI
import Domain

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
    
    func onAppear() async {
        try? await Task.sleep(nanoseconds: 2 * .second)
        let token = localRepository.getToken()
        if token.isEmpty {
            withAnimation {
                launchState = .login
            }
        }
    }
}
