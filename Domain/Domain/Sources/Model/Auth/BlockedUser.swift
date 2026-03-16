//
//  BlockedUser.swift
//  Domain
//
//  Created by 이조은 on 3/15/26.
//

public struct BlockedUser {
    public let userId: Int
    public let nickname: String
    public let profileImage: String

    public init(
        userId: Int,
        nickname: String,
        profileImage: String
    ) {
        self.userId = userId
        self.nickname = nickname
        self.profileImage = profileImage
    }
}
