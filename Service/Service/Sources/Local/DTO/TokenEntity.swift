//
//  TokenEntity.swift
//  Service
//
//  Created by 문종식 on 2/14/26.
//

import Domain

struct TokenEntity: Codable {
    let refreshToken: String
    let accessToken: String
    
    init(_ token: Token) {
        self.refreshToken = token.refreshToken
        self.accessToken = token.accessToken
    }
}
