//
//  Project.swift
//  Manifests
//
//  Created by 문종식 on 1/18/26.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Module.Feature.createVote.project(
    dependencies: [
        Module.core.toDependency,
        Module.domain.toDependency,
        Module.designSystem.toDependency,
        Module.Feature.login.toDependency,
    ]
)
