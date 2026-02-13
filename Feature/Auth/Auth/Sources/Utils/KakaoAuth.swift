//
//  KakaoAuth.swift
//  Auth
//
//  Created by 문종식 on 2/13/26.
//

import KakaoSDKAuth
import KakaoSDKCommon
import KakaoSDKUser

struct KakaoAuth {
    public func requestLogin() {
        /// 카카오톡 사용 여부 확인
        if UserApi.isKakaoTalkLoginAvailable() {
            UserApi.shared.loginWithKakaoTalk { oauthToken, error in
                guard let oauthToken else {
                    loginWithKakaoAccount()
                    return
                }
                handleKakaoLoginSuccess(oauthToken)
            }
        } else {
            /// 카카오 웹 로그인
            loginWithKakaoAccount()
        }
    }
    
    /// 카카오 웹 로그인
    private func loginWithKakaoAccount() {
        UserApi.shared.loginWithKakaoAccount { oauthToken, error in
            guard let oauthToken else {
                return
            }
            handleKakaoLoginSuccess(oauthToken)
        }
    }
    
    private func handleKakaoLoginSuccess(_ oauthToken: OAuthToken) {
        print(
            "Kakao Login Success:\n" +
            "accessToken(\(oauthToken.accessToken.count))\n" +
            "refreshToken(\(oauthToken.refreshToken.count))"
        )
        // TODO: accessToken 전달
    }
}
