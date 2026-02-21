//
//  TokenEntity+Extension.swift
//  Service
//
//  Created by 문종식 on 2/22/26.
//

import Domain

extension TokenEntity {
    func toDomain() -> Token {
        Token(
            refreshToken: refreshToken,
            accessToken: accessToken,
            tokenType: tokenType
        )
    }
}
