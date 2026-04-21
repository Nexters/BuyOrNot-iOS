//
//  Project.swift
//  Manifests
//
//  Created by 문종식 on 1/18/26.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    name: Module.core.moduleName,
    targets: [
        Module.core.target(
            dependencies: [
                .external(name: "Then"),
            ],
            infoPlist: .default,
            entitlements: nil,
            settings: nil
        ),
        .target(
            name: "CoreTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "\(ProjectEnvironment.bundleIdPrefix).coreTests",
            deploymentTargets: ProjectEnvironment.deploymentTarget,
            infoPlist: .default,
            sources: ["Core/Tests/**"],
            dependencies: [
                .target(name: Module.core.moduleName),
            ]
        ),
    ],
    schemes: [
        Module.core.scheme,
    ]
)
