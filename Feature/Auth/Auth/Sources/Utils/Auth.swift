//
//  Auth.swift
//  Auth
//
//  Created by 문종식 on 2/13/26.
//

import GoogleSignIn
import KakaoSDKAuth
import KakaoSDKCommon

public struct Auth {
    private struct Constants {
        static let googleClientID: String = "CLIENT_ID"
        static let kakaoNativeAppKey: String = "KAKAO_NATIVE_APP_KEY"
        static let appleClientID: String = "TODO"
    }
    
    public init() {
        
    }
    
    /// didFinishLaunchingWithOptions 에서 SDK 인증을 수행합니다.
    public func initAuth() {
        if let appKey = getAPIKey(with: .kakao) {
            KakaoSDK.initSDK(appKey: appKey)
        }
    }
    
    @MainActor
    public func open(url: URL) -> Bool? {
        if GIDSignIn.sharedInstance.handle(url) {
            return true
        }
        
        if AuthApi.isKakaoTalkLoginUrl(url) {
            return AuthController.handleOpenUrl(url: url)
        }
        
        return nil
    }
    
    func getAPIKey(with type: LoginType) -> String? {
        let key = switch type {
        case .google:
            Constants.googleClientID
        case .apple:
            Constants.appleClientID
        case .kakao:
            Constants.kakaoNativeAppKey
        }
        let bundleObject = Bundle.main.object(
            forInfoDictionaryKey: key
        )
        return bundleObject as? String
    }
}
