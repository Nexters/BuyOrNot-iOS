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
}
