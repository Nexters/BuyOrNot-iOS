//
//  AuthSessionResponse+Extension.swift
//  Service
//
//  Created by 문종식 on 2/14/26.
//

import Domain

extension AuthSessionResponse {
    func toDomain() -> AuthSession {
        AuthSession(
            token: Token(
                refreshToken: refreshToken,
                accessToken: accessToken,
                tokenType: tokenType
            ),
            user: User(
                id: user.id,
                nickname: user.nickname,
                profileImage: user.profileImage,
                socialAccount: user.socialAccount ?? "",
                email: user.email ?? ""
            )
        )
    }
}
