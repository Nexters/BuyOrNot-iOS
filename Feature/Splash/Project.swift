//
//  Project.swift
//  Manifests
//
//  Created by 이조은 on 2/14/26.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Module.Feature.splash.project(
    dependencies: [
        Module.core.toDependency,
        Module.domain.toDependency,
        Module.designSystem.toDependency,
    ]
)
