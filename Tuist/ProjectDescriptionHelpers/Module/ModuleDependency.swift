//
//  ModuleDependency.swift
//  Manifests
//
//  Created by 문종식 on 1/26/26.
//

import ProjectDescription

protocol ModuleDependency: ModuleName {
    var toDependency: TargetDependency { get }
}

extension ModuleDependency {
    var toDependency: TargetDependency {
        .project(
            target: moduleName,
            path: projectPath,
        )
    }
}
