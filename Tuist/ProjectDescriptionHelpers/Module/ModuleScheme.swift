//
//  ModuleScheme.swift
//  Manifests
//
//  Created by 문종식 on 1/25/26.
//

import ProjectDescription

public protocol ModuleScheme: ModuleName {
    var scheme: Scheme { get }
}

extension ModuleScheme {
    public var scheme: Scheme {
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
