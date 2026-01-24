//
//  Project.swift
//  Manifests
//
//  Created by 문종식 on 1/18/26.
//

import ProjectDescription

let project = Project(
    name: "DesignSystem",
    targets: [
        .target(
            name: "DesignSystem",
            destinations: .iOS,
            product: .staticFramework,
            bundleId: "com.sseotdabwa.buyornot.designsystem",
            deploymentTargets: .iOS("18.0"),
            infoPlist: .default,
            sources: ["DesignSystem/Sources/**"],
            resources: ["DesignSystem/Resources/**"],
            dependencies: [
                .project(target: "Core", path: .relativeToRoot("Core")),
            ]
        )
    ],
    schemes: [
        .scheme(
            name: "DesignSystem",
            shared: true,
            buildAction: .buildAction(targets: ["DesignSystem"]),
        )
    ]
)
