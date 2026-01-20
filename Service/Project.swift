//
//  Project.swift
//  Manifests
//
//  Created by 문종식 on 1/18/26.
//

import ProjectDescription

let project = Project(
    name: "Service",
    targets: [
        .target(
            name: "Service",
            destinations: .iOS,
            product: .staticFramework,
            bundleId: "com.test.tuist.service",
            deploymentTargets: .iOS("18.0"),
            infoPlist: .default,
            sources: ["Targets/Service/Sources/**"],
            resources: ["Targets/Service/Resources/**"],
            dependencies: [
                .project(target: "Core", path: .relativeToRoot("Core"))
            ]
        )
    ],
    schemes: [
        .scheme(
            name: "Service",
            shared: true,
            buildAction: .buildAction(targets: ["Service"]),
        )
    ]
)
