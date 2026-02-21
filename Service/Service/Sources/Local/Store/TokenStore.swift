//
//  TokenStore.swift
//  Service
//
//  Created by 문종식 on 2/14/26.
//

import Domain

final class TokenStore: EntityStore {
    let client: UserDefaultsClientProtocol
    let key: UserDefaultsKey = .token
    
    init() {
        self.client = UserDefaultsClient()
    }
    
    func saveToken(_ token: Token) {
        let entity = TokenEntity(
            refreshToken: token.refreshToken,
            accessToken: token.accessToken,
            tokenType: token.tokenType
        )
        client.set(entity, for: key)
    }
    
    func getToken() -> Token? {
        let entity: TokenEntity? = client.get(for: key)
        return entity?.toDomain()
    }
    
    func removeToken() {
        client.remove(for: key)
    }
}
