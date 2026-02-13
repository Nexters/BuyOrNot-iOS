//
//  Project.swift
//  Manifests
//
//  Created by 문종식 on 1/18/26.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Module.Feature.splash.project(
    dependencies: [
        Module.core.toDependency,
        Module.domain.toDependency,
        Module.designSystem.toDependency,
        Module.Feature.auth.toDependency,
    ]
)
