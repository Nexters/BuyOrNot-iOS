//
//  LoginScope.swift
//  App
//
//  Created by 문종식 on 2/14/26.
//

import Swinject

extension ObjectScope {
    static let login = ObjectScope(
        storageFactory: PermanentStorage.init,
    )
}
