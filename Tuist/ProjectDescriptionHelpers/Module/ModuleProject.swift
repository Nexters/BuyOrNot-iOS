//
//  ModuleProject.swift
//  Manifests
//
//  Created by 문종식 on 1/26/26.
//

import ProjectDescription

protocol ModuleProject: ModuleName, ModuleScheme, ModuleTarget, ModuleDependency {
    func project(dependencies: [TargetDependency]) -> Project
}

extension ModuleProject {
    func project(dependencies: [TargetDependency]) -> Project {
        .init(
            name: moduleName,
            targets: [
                target(
                    dependencies: dependencies
                )
            ],
            schemes: [
                scheme
            ]
        )
    }
}
