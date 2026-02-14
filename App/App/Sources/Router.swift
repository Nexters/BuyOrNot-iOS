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

@Observable
class Router {
    var path: [AppDestination] = []
    var showCreateVote: Bool = false

    func navigate(to destination: AppDestination) {
        path.append(destination)
    }

    func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }

    func popToRoot() {
        path.removeAll()
    }
}
