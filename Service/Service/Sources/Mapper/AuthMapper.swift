//
//  AuthMapper.swift
//  Service
//
//  Created by 문종식 on 2/14/26.
//

import Domain

struct AuthMapper {
    func toDomain(
        _ response: TokenResponse
    ) -> User {
        User(
            id: response.user.id,
            nickname: response.user.nickname,
            profileImage: response.user.profileImage,
            socialAccount: response.user.socialAccount,
            email: response.user.email,
            accessToken: response.accessToken,
            refreshToken: response.refreshToken,
            tokenType: response.tokenType,
        )
    }
}
