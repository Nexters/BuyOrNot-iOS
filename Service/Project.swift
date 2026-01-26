//
//  Project.swift
//  Manifests
//
//  Created by 문종식 on 1/18/26.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Module.service.project(
    dependencies: [
        Module.domain.toDependency,
        Module.core.toDependency,
    ]
)
