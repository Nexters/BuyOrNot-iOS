//
//  Project.swift
//  Manifests
//
//  Created by 문종식 on 1/18/26.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Module.app.project(
    dependencies: [
        Module.Feature.login.toDependency,
        .external(name: "Swinject"),
    ],
    infoPlist: .extendingDefault(
        with: [
            "UISupportedInterfaceOrientations": [
                "UIInterfaceOrientationPortrait",
            ],
            "UISupportedInterfaceOrientations~ipad": [
                "UIInterfaceOrientationPortrait",
            ],
            "UILaunchScreen": .dictionary(
                ["UILaunchScreen": .dictionary([:])]
            ),
            "CFBundleDisplayName" : "살까말까",
        ]
    )
)
