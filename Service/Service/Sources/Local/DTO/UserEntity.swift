//
//  UserEntity.swift
//  Service
//
//  Created by 문종식 on 2/22/26.
//

struct UserEntity: Codable {
    let id: Int
    let email: String
    let nickname: String
    let profileImageUrl: String
    let socialAccount: String
    
    init(id: Int, email: String, nickname: String, profileImageUrl: String, socialAccount: String) {
        self.id = id
        self.email = email
        self.nickname = nickname
        self.profileImageUrl = profileImageUrl
        self.socialAccount = socialAccount
    }
}
