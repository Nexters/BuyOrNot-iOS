//
//  Router.swift
//  App
//
//  Created by 이조은 on 2/14/26.
//

import SwiftUI

enum AppDestination: Hashable {
    case notification
    case myPage
}

enum AuthDestination: Hashable {
    case terms
    case accountSetting
    case deleteAccount
}

@Observable
class Router {
    var path = NavigationPath()
    var showCreateVote: Bool = false

    func navigate<D: Hashable>(to destination: D) {
        path.append(destination)
    }

    func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }

    func popToRoot() {
        path = NavigationPath()
    }
}
