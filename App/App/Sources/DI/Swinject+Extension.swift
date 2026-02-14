//
//  Swinject+Extension.swift
//  App
//
//  Created by 문종식 on 2/14/26.
//

import Swinject

extension Container {
    func resolve<T>() -> T {
        guard let object = self.resolve(T.self) else {
            fatalError("Dependency resolution failed: \(T.self)")
        }
        return object
    }
}

extension Resolver {
    func resolve<T>() -> T {
        guard let object = self.resolve(T.self) else {
            fatalError("Dependency resolution failed: \(T.self)")
        }
        return object
    }
}

