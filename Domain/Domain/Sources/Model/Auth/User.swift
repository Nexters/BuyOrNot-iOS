//
//  User.swift
//  Domain
//
//  Created by 문종식 on 2/14/26.
//

public struct User {
    let id: Int
    let nickname: String
    let profileImage: String
    let socialAccount: SocialAccount?
    let email: String
    
    let accessToken: String
    let refreshToken: String
    let tokenType: String
    
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
