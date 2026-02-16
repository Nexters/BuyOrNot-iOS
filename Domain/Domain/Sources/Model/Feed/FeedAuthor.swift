//
//  FeedAuthor.swift
//  Domain
//
//  Created by 문종식 on 2/16/26.
//

public struct FeedAuthor {
    public let id: Int
    public let nickname: String
    public let profileImage: String
    
    public init(id: Int, nickname: String, profileImage: String) {
        self.id = id
        self.nickname = nickname
        self.profileImage = profileImage
    }
}
