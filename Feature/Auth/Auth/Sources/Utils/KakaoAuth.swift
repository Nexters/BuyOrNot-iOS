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
        if UserApi.isKakaoTalkLoginAvailable() {
            UserApi.shared.loginWithKakaoTalk { oauthToken, error in
                guard let oauthToken else {
                    loginWithKakaoAccount()
                    return
                }
                handleKakaoLoginSuccess(oauthToken)
            }
        } else {
            loginWithKakaoAccount()
        }
    }
    
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
    }
}
