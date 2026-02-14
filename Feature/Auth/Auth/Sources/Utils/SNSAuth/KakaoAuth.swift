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
    public func requestLogin(
        _ completeHandler: @escaping (OAuthToken?) -> Void
    ) {
        /// 카카오톡 사용 여부 확인
        if UserApi.isKakaoTalkLoginAvailable() {
            UserApi.shared.loginWithKakaoTalk { oauthToken, error in
                guard let oauthToken else {
                    loginWithKakaoAccount(completeHandler)
                    return
                }
                completeHandler(oauthToken)
            }
        } else {
            /// 카카오 웹 로그인
            loginWithKakaoAccount(completeHandler)
        }
    }
    
    /// 카카오 웹 로그인
    private func loginWithKakaoAccount(
        _ completeHandler: @escaping (OAuthToken?) -> Void
    ) {
        UserApi.shared.loginWithKakaoAccount { oauthToken, error in
            completeHandler(oauthToken)
        }
    }
}
