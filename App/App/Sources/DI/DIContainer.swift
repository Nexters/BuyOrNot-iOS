//
//  PlaceHolder.swift
//  Manifests
//
//  Created by 문종식 on 1/18/26.
//

import Swinject
import SwiftUI

final class DIContainer: ObservableObject {
    private let container = Container()
    
    init() {
        registerRepositories(container)
        registerUseCases(container)
        registerViewModels(container)
    }
    
    func resolve<T>() -> T {
        container.resolve()
    }
    
    func resetLoginScope() {
        container.resetObjectScope(.login)
    }
}

