//
//  Project.swift
//  Manifests
//
//  Created by 문종식 on 1/18/26.
//

import ProjectDescription

let project = Project(
    name: "Domain",
    targets: [
        .target(
            name: "Domain",
            destinations: .iOS,
            product: .staticFramework,
            bundleId: "com.sseotdabwa.buyornot.domain",
            deploymentTargets: .iOS("18.0"),
            infoPlist: .default,
            sources: ["Targets/Domain/Sources/**"],
            resources: ["Targets/Domain/Resources/**"],
            dependencies: [
                .project(target: "Service", path: .relativeToRoot("Service")),
                .project(target: "Core", path: .relativeToRoot("Core")),
            ]
        )
    ],
    schemes: [
        .scheme(
            name: "Domain",
            shared: true,
            buildAction: .buildAction(targets: ["Domain"]),
        )
    ]
)
