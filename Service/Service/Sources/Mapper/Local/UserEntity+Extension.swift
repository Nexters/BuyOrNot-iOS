//
//  UserEntity+Extension.swift
//  Service
//
//  Created by 문종식 on 2/22/26.
//

import Domain

extension UserEntity {
    func toDomain() -> User {
        User(
            id: self.id,
            nickname: self.nickname,
            profileImage: self.profileImageUrl,
            socialAccount: self.socialAccount,
            email: self.email
        )
    }
}
