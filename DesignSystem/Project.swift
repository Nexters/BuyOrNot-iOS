//
//  Project.swift
//  Manifests
//
//  Created by 문종식 on 1/18/26.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Module.designSystem.project(
    dependencies: [
        Module.core.toDependency
    ],
    infoPlist: .extendingDefault(
        with: [
            "UIAppFonts" : .array(
                [
                    .string("Pretendard-Bold.otf"),
                    .string("Pretendard-SemiBold.otf"),
                    .string("Pretendard-Regular.otf"),
                    .string("Pretendard-Medium.otf"),
                ]
            ),
        ]
    )
)
