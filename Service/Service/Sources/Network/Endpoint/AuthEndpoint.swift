//
//  AuthEndpoint.swift
//  Service
//
//  Created by 문종식 on 2/14/26.
//

enum AuthEndpoint: Endpoint {
    case kakaoLogin(KakaoAuthRequest)
    case googleLogin(GoogleAuthRequest)
    case appleLogin(AppleAuthRequest)
    case refreshToken(RefreshTokenRequest)
    case logout(LogoutRequest)
    
    var path: String {
        let prefix = "/auth"
        let path = switch self {
        case .kakaoLogin:
            "/kakao/login"
        case .googleLogin:
            "/google/login"
        case .appleLogin:
            "/apple/login"
        case .refreshToken:
            "/refresh"
        case .logout:
            "/logout"
        }
        return prefix + path
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var body: (any Encodable)? {
        switch self {
        case .kakaoLogin(let kakaoAuthRequest):
            kakaoAuthRequest
        case .googleLogin(let googleAuthRequest):
            googleAuthRequest
        case .appleLogin(let appleAuthRequest):
            appleAuthRequest
        case .refreshToken(let tokenRefreshRequest):
            tokenRefreshRequest
        case .logout(let logoutRequest):
            logoutRequest
        }
    }
}
