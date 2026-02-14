//
//  User.swift
//  Domain
//
//  Created by 문종식 on 2/14/26.
//

public struct User {
    public let id: Int
    public let nickname: String
    public let profileImage: String
    public let socialAccount: SocialAccount?
    public let email: String
    
    public let accessToken: String
    public let refreshToken: String
    public let tokenType: String
    
    public init(
        id: Int,
        nickname: String,
        profileImage: String,
        socialAccount: String,
        email: String,
        accessToken: String,
        refreshToken: String,
        tokenType: String
    ) {
        self.id = id
        self.nickname = nickname
        self.profileImage = profileImage
        self.socialAccount = SocialAccount(
            rawValue: socialAccount
        )
        self.email = email
        self.accessToken = accessToken
        self.refreshToken = refreshToken
        self.tokenType = tokenType
    }
}
