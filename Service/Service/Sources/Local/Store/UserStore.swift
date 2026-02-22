//
//  UserStore.swift
//  Service
//
//  Created by 문종식 on 2/14/26.
//

import Domain

final class UserStore: EntityStore {
    let client: UserDefaultsClientProtocol
    let key: UserDefaultsKey = .user
    
    init() {
        self.client = UserDefaultsClient()
    }
    
    func saveUser(_ user: User) {
        let entity = UserEntity(
            id: user.id,
            email: user.email,
            nickname: user.nickname,
            profileImageUrl: user.profileImage,
            socialAccount: user.socialAccount?.rawValue ?? ""
        )
        client.set(entity, for: key)
    }
    
    func getUser() -> User? {
        let entity: UserEntity? = client.get(for: key)
        return entity?.toDomain()
    }
    
    func removeUser() {
        client.remove(for: key)
    }
}
