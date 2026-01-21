//
//  Project.swift
//  Manifests
//
//  Created by 문종식 on 1/18/26.
//

import ProjectDescription

let project = Project(
    name: "Login",
    targets: [
        .target(
            name: "Login",
            destinations: .iOS,
            product: .staticFramework,
            bundleId: "com.sseotdabwa.buyornot.login",
            deploymentTargets: .iOS("18.0"),
            infoPlist: .default,
            sources: ["Targets/Login/Sources/**"],
            resources: ["Targets/Login/Resources/**"],
            dependencies: [
                .project(target: "Core", path: .relativeToRoot("Core")),
                .project(target: "Domain", path: .relativeToRoot("Domain")),
                .project(target: "DesignSystem", path: .relativeToRoot("DesignSystem")),
            ]
        )
    ],
    schemes: [
        .scheme(
            name: "Login",
            shared: true,
            buildAction: .buildAction(targets: ["Login"]),
        )
    ]
)
