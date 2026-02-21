//
//  AuthEndpoint.swift
//  Service
//
//  Created by 문종식 on 2/14/26.
//

enum AuthEndpoint: Endpoint {
    case postKakaoLogin(KakaoAuthRequest)
    case postGoogleLogin(GoogleAuthRequest)
    case postAppleLogin(AppleAuthRequest)
    case postRefreshToken(RefreshTokenRequest)
    case postLogout(LogoutRequest)
    
    var path: String {
        let prefix = "/auth"
        let path = switch self {
        case .postKakaoLogin:
            "/kakao/login"
        case .postGoogleLogin:
            "/google/login"
        case .postAppleLogin:
            "/apple/login"
        case .postRefreshToken:
            "/refresh"
        case .postLogout:
            "/logout"
        }
        return version.path + prefix + path
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var body: (any Encodable)? {
        switch self {
        case .postKakaoLogin(let kakaoAuthRequest):
            kakaoAuthRequest
        case .postGoogleLogin(let googleAuthRequest):
            googleAuthRequest
        case .postAppleLogin(let appleAuthRequest):
            appleAuthRequest
        case .postRefreshToken(let tokenRefreshRequest):
            tokenRefreshRequest
        case .postLogout(let logoutRequest):
            logoutRequest
        }
    }
}
