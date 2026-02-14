//
//  LoginViewModel.swift
//  Auth
//
//  Created by 문종식 on 2/11/26.
//

import SwiftUI
import UIKit

import DesignSystem
import Core

import GoogleSignIn
import KakaoSDKAuth
import KakaoSDKCommon

@MainActor
public final class LoginViewModel: ObservableObject {
    private let auth = Auth()
    private let appleAuth = AppleAuth()

    @Published var url: URL?
    @Published var loginErrorMessage: String?
    @Published var snackBar = BNSnackBarManager()
    
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
        googleAuth.requestLogin { [weak self] gidSignInResult in
            guard let gidSignInResult else {
                self?.showErrorSnackBar()
                return
            }
            print(gidSignInResult)
        }
    }
    
    /// 애플 로그인
    private func loginWithApple() {
        appleAuth.requestLogin { [weak self] authorizationCode in
            defer {
                AppleAuth.clearDelegate()
            }
            guard let authorizationCode else {
                self?.showErrorSnackBar()
                return
            }
            print(authorizationCode)
        }
    }
    
    /// 카카오 로그인
    private func loginWithKakao() {
        let kakaoAuth = KakaoAuth()
        kakaoAuth.requestLogin { [weak self] oauthToken in
            guard let oauthToken else {
                self?.showErrorSnackBar()
                return
            }
            print(oauthToken)
        }
    }
    
    /// 소셜 로그인 외부 URL 핸들링
    @MainActor
    func handleAuthUrl(_ url: URL) {
        if GIDSignIn.sharedInstance.handle(url) {
            return
        }
        
        if AuthApi.isKakaoTalkLoginUrl(url) {
            _ = AuthController.handleOpenUrl(url: url)
        }
    }
    
    private func showErrorSnackBar() {
        let item = BNSnackBarItem(
            text: "오류가 발생했습니다. 잠시 후 다시 시도해주세요.",
            icon: .close,
            color: .type(.red100),
        )
        snackBar.addItem(item)
    }
}
