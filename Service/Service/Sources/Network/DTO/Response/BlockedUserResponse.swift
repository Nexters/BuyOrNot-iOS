//
//  BlockedUserResponse.swift
//  Service
//
//  Created by 이조은 on 3/15/26.
//

import Domain

struct BlockedUserResponse: Decodable {
    let userId: Int
    let nickname: String
    let profileImage: String
    let blockedAt: String

    func toDomain() -> BlockedUser {
        BlockedUser(
            userId: userId,
            nickname: nickname,
            profileImage: profileImage
        )
    }
}
