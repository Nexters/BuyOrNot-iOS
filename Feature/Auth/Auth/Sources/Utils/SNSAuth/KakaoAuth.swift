//
//  KakaoAuth.swift
//  Auth
//
//  Created by 문종식 on 2/13/26.
//

import KakaoSDKAuth
import KakaoSDKCommon
import KakaoSDKUser
import Foundation

struct KakaoAuth {
    private var appKey: String? {
        let key: String = "KAKAO_NATIVE_APP_KEY"
        let bundleObject = Bundle.main.object(
            forInfoDictionaryKey: key
        )
        return bundleObject as? String
    }
    
    public func requestLogin(
        _ completeHandler: @escaping (OAuthToken?) -> Void
    ) {
        guard let appKey else{
#if DEBUG
            print("🚨 Kakao Login: AppKey is nil")
#endif
            return
        }
        KakaoSDK.initSDK(appKey: appKey)
        
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
            if let error {
#if DEBUG
                print("🚨 Kakao Login: \(error)")
#endif
                completeHandler(nil)
                return
            }
            
            guard let oauthToken else {
#if DEBUG
                print("🚨 Kakao Login: OAuthToken is nil.")
#endif
                completeHandler(nil)
                return
            }
            completeHandler(oauthToken)
        }
    }
}
