//
//  ModuleProject.swift
//  Manifests
//
//  Created by 문종식 on 1/26/26.
//

import ProjectDescription

public protocol ModuleProject: ModuleScheme, ModuleTarget, ModuleDependency {
    func project(
        dependencies: [TargetDependency],
        infoPlist: InfoPlist,
        entitlements: Entitlements?,
        settings: Settings?
    ) -> Project
}

extension ModuleProject {
    public func project(
        dependencies: [TargetDependency] = [],
        infoPlist: InfoPlist = .default,
        entitlements: Entitlements? = nil,
        settings: Settings? = nil
    ) -> Project {
        .init(
            name: moduleName,
            targets: [
                target(
                    dependencies: dependencies,
                    infoPlist: infoPlist,
                    entitlements: entitlements,
                    settings: settings
                )
            ],
            schemes: [
                scheme
            ],
        )
    }
}

