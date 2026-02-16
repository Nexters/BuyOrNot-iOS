//
//  UserResponse+Extension.swift
//  Service
//
//  Created by 문종식 on 2/14/26.
//

import Domain

extension UserResponse {
    func toDomain() -> User {
        User(
            id: self.id,
            nickname: self.nickname,
            profileImage: self.profileImage,
            socialAccount: self.socialAccount ?? "",
            email: self.email ?? "",
        )
    }
}
