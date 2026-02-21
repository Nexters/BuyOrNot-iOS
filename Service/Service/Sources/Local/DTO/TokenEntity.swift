//
//  TokenEntity.swift
//  Service
//
//  Created by 문종식 on 2/22/26.
//

struct TokenEntity: Codable {
    let refreshToken: String
    let accessToken: String
    let tokenType: String
    
    init(refreshToken: String, accessToken: String, tokenType: String) {
        self.refreshToken = refreshToken
        self.accessToken = accessToken
        self.tokenType = tokenType
    }
}
