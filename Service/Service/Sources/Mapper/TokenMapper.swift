//
//  TokenMapper.swift
//  Service
//
//  Created by 문종식 on 2/14/26.
//

import Domain

struct TokenMapper {
    func toDomain(
        _ entity: TokenEntity
    ) -> Token {
        Token(
            refreshToken: entity.refreshToken,
            accessToken: entity.accessToken
        )
    }
}
