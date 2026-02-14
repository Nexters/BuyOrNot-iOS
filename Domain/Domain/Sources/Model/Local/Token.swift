//
//  Token.swift
//  Domain
//
//  Created by 문종식 on 2/14/26.
//

public struct Token {
    public let refreshToken: String
    public let accessToken: String
    
    public init(
        refreshToken: String,
        accessToken: String
    ) {
        self.refreshToken = refreshToken
        self.accessToken = accessToken
    }
}
