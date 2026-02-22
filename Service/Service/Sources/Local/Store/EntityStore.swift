//
//  EntityStore.swift
//  Service
//
//  Created by 문종식 on 2/22/26.
//

protocol EntityStore {
    var client: UserDefaultsClientProtocol { get }
    var key: UserDefaultsKey { get }
}
