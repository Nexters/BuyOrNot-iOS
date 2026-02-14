//
//  TokenService.swift
//  Service
//
//  Created by 문종식 on 2/14/26.
//

final class TokenService {
    private enum Key {
        static let refreshToken = "AUTH_REFRESH_TOKEN"
        static let accessToken = "AUTH_ACCESS_TOKEN"
    }
    
    private let store: UserDefaultsStore
    
    init(store: UserDefaultsStore = UserDefaultsStore()) {
        self.store = store
    }
    
    // MARK: - RefreshToken
    func saveRefreshToken(_ token: String) {
        store.set(token, forKey: Key.refreshToken)
    }
    
    func getRefreshToken() -> String? {
        store.get(String.self, forKey: Key.refreshToken)
    }
    
    func removeRefreshToken() {
        store.removeValue(forKey: Key.refreshToken)
    }
    
    // MARK: - AccessToken
    func saveAccessToken(_ token: String) {
        store.set(token, forKey: Key.accessToken)
    }
    
    func getAccessToken() -> String? {
        store.get(String.self, forKey: Key.accessToken)
    }
    
    func removeAccessToken() {
        store.removeValue(forKey: Key.accessToken)
    }
}
