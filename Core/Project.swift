//
//  Project.swift
//  Manifests
//
//  Created by 문종식 on 1/18/26.
//

import ProjectDescription

let project = Project(
    name: "Core",
    targets: [
        .target(
            name: "Core",
            destinations: .iOS,
            product: .staticFramework,
            bundleId: "com.sseotdabwa.buyornot.core",
            deploymentTargets: .iOS("18.0"),
            infoPlist: .default,
            sources: ["Targets/Core/Sources/**"],
            resources: ["Targets/Core/Resources/**"],
        )
    ],
    schemes: [
        .scheme(
            name: "Core",
            shared: true,
            buildAction: .buildAction(targets: ["Core"]),
        )
    ]
)
