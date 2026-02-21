//
//  TokenResponse+Extension.swift
//  Service
//
//  Created by 문종식 on 2/14/26.
//

import Domain

extension TokenResponse {
    func toToken() -> Token {
        Token(
            refreshToken: self.refreshToken,
            accessToken: self.accessToken,
            tokenType: self.tokenType
        )
    }
    
    func toUser() -> User {
        User(
            id: self.user.id,
            nickname: self.user.nickname,
            profileImage: self.user.profileImage,
            socialAccount: self.user.socialAccount ?? "",
            email: self.user.email ?? ""
        )
    }
}
