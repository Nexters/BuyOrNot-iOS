//
//  LoginViewModel.swift
//  Auth
//
//  Created by 문종식 on 2/11/26.
//

import SwiftUI
import Core

final class LoginViewModel: ObservableObject {
    @Published var url: URL?
    
    var policyText: AttributedString {
        let serviceTermsURL = URL(string: Constants.serviceTermsURLString)
        let privacyPolicyURL = URL(string: Constants.privacyPolicyURLString)
        var text = AttributedString(
            "가입을 진행하시면 서비스약관 및 개인정보처리방침에\n동의 하시는 것으로 간주합니다."
        )
        
        if let range = text.range(of: "서비스약관") {
            if let serviceTermsURL {
                text[range].link = serviceTermsURL
            }
            text[range].underlineStyle = .single
        }
        
        if let range = text.range(of: "개인정보처리방침") {
            if let privacyPolicyURL {
                text[range].link = privacyPolicyURL
            }
            text[range].underlineStyle = .single
        }
        
        return text
    }
    
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
