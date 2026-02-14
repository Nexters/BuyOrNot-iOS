//
//  UserResponse.swift
//  Service
//
//  Created by 문종식 on 2/14/26.
//

struct UserResponse: Decodable {
    let id: Int
    let nickname: String
    let profileImage: String
    let socialAccount: String
    let email: String
}
