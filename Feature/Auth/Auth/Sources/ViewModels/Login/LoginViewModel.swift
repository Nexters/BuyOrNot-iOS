//
//  LoginViewModel.swift
//  Auth
//
//  Created by 문종식 on 2/11/26.
//

import SwiftUI
import Core
import UIKit

final class LoginViewModel: ObservableObject {
    private let auth = Auth()
    private static var isKakaoSDKInitialized = false

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
    
    /// 구글 로그인
    private func loginWithGoogle() {
        let googleAuth = GoogleAuth()
        googleAuth.requestLogin()
    }
    
    /// 애플 로그인
    private func loginWithApple() {
        
    }
    
    /// 카카오 로그인
    private func loginWithKakao() {
        let kakaoAuth = KakaoAuth()
        kakaoAuth.requestLogin()
    }
    
    /// 소셜 로그인 외부 URL 핸들링
    @MainActor
    func handleAuthUrl(_ url: URL) {
        _ = auth.open(url: url)
    }
}
