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
import Domain

import GoogleSignIn
import KakaoSDKAuth
import KakaoSDKCommon

public final class LoginViewModel: ObservableObject {
    private let authRepository: AuthRepository
    private let tokenRepository: TokenRepository
    private let userRepository: UserRepository
    private let delegate: LoginDelegate?
    
    public init(
        authRepository: AuthRepository,
        tokenRepository: TokenRepository,
        userRepository: UserRepository,
        argument: LoginViewModel.Argument
    ) {
        self.authRepository = authRepository
        self.tokenRepository = tokenRepository
        self.userRepository = userRepository
        self.delegate = argument.delegate
    }
    
    @Published var url: URL?
    @Published var loginErrorMessage: String?
    @Published var snackBar = BNSnackBarManager()
    
    var policyText: AttributedString {
        let serviceTermsURL = URL(string: Constants.getValue(with: .serviceTermsURL))
        let privacyPolicyURL = URL(string: Constants.getValue(with: .privacyPolicyURL))
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
        text.foregroundColor = ColorPalette.gray600
        return text
    }
    
    var guestLoginText: AttributedString {
        var text = AttributedString("비회원으로 시작하기")
        text.underlineStyle = .single
        text.foregroundColor = ColorPalette.gray700
        return text
    }
    
    func guestLogin() {
        delegate?.completeLogin(.guest)
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
            Task { [weak self] in
                guard let idToken = gidSignInResult?.user.idToken?.tokenString,
                      let self else {
                    self?.showErrorSnackBar()
                    return
                }
                do {
                    let session = try await authRepository.loginWithGoogle(
                        idToken: idToken
                    )
                    tokenRepository.saveToken(session.token)
                    userRepository.cacheUser(session.user)
                    delegate?.completeLogin(.member)
                } catch(let error) {
#if DEBUG
                    print("🚨 Login failed: \(error)")
#endif
                    showErrorSnackBar()
                }
            }
        }
    }
    
    /// 애플 로그인
    private func loginWithApple() {
        let appleAuth = AppleAuth()
        appleAuth.requestLogin { [weak self] authorizationCode in
            Task { [weak self] in
                guard let authorizationCode, let self else {
                    self?.showErrorSnackBar()
                    appleAuth.clearDelegate()
                    return
                }
                do {
                    let session = try await authRepository.loginWithApple(
                        authorizationCode: authorizationCode
                    )
                    tokenRepository.saveToken(session.token)
                    userRepository.cacheUser(session.user)
                    delegate?.completeLogin(.member)
                } catch(let error) {
#if DEBUG
                    print("🚨 Login failed: \(error)")
#endif
                    showErrorSnackBar()
                }
                appleAuth.clearDelegate()
            }
        }
    }
    
    /// 카카오 로그인
    private func loginWithKakao() {
        let kakaoAuth = KakaoAuth()
        kakaoAuth.requestLogin { [weak self] oauthToken in
            Task { [weak self] in
                guard let oauthToken, let self else {
                    self?.showErrorSnackBar()
                    return
                }
                do {
                    let session = try await authRepository.loginWithKakao(
                        accessToken: oauthToken.accessToken
                    )
                    tokenRepository.saveToken(session.token)
                    userRepository.cacheUser(session.user)
                    delegate?.completeLogin(.member)
                } catch(let error) {
#if DEBUG
                    print("🚨 Login failed: \(error)")
#endif
                    showErrorSnackBar()
                }
            }
        }
    }
    
    /// 소셜 로그인 외부 URL 핸들링
    func handleAuthUrl(_ url: URL) {
        Task { @MainActor in
            if GIDSignIn.sharedInstance.handle(url) {
                return
            }
            
            if AuthApi.isKakaoTalkLoginUrl(url) {
                _ = AuthController.handleOpenUrl(url: url)
            }
        }
    }
    
    private func showErrorSnackBar() {
        let item = BNSnackBarItem(
            text: "오류가 발생했습니다. 잠시 후 다시 시도해주세요.",
            icon: .close,
            color: ColorPalette.red100,
        )
        snackBar.addItem(item)
    }
}

public extension LoginViewModel {
    struct Argument {
        let delegate: LoginDelegate?
        
        public init(delegate: LoginDelegate?) {
            self.delegate = delegate
        }
    }
}
