//
//  LoginViewModel.swift
//  Auth
//
//  Created by 문종식 on 2/11/26.
//

import SwiftUI

final class LoginViewModel: ObservableObject {
    func login(with type: LoginType) {
        switch type {
        case .google:
            loginWithGoogle()
        case .apple:
            loginWithApple()
        case .kakao:
            loginWithKakao()
        }
    }
    
    private func loginWithGoogle() {
        
    }
    
    private func loginWithApple() {
        
    }
    
    private func loginWithKakao() {
        
    }
}
