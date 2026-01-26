//
//  ModuleScheme.swift
//  Manifests
//
//  Created by 문종식 on 1/25/26.
//

import ProjectDescription

protocol ModuleScheme: ModuleName {
    var scheme: Scheme { get }
}

extension ModuleScheme {
    var scheme: Scheme {
        .scheme(
            name: moduleName,
            shared: true,
            buildAction: .buildAction(
                targets: [
                    .target(moduleName)
                ]
            ),
        )
    }
}
