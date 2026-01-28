//
//  ModuleTarget.swift
//  Manifests
//
//  Created by 문종식 on 1/25/26.
//

import ProjectDescription

public protocol ModuleTarget: ModuleName {
    func target(
        dependencies: [TargetDependency],
        infoPlist: InfoPlist
    ) -> Target
    var product: Product { get }
}

public extension ModuleTarget {
    private var bundleId: String {
        var result = ProjectEnvironment.bundleIdPrefix
        if product == .staticFramework {
            result += ".\(moduleName.lowercased())"
        }
        return result
    }
    
    func target(
        dependencies: [TargetDependency],
        infoPlist: InfoPlist
    ) -> Target {
        .target(
            name: moduleName,
            destinations: .iOS,
            product: product,
            bundleId: bundleId,
            deploymentTargets: ProjectEnvironment.deploymentTarget,
            infoPlist: infoPlist,
            sources: ["\(moduleName)/Sources/**"],
            resources: ["\(moduleName)/Resources/**"],
            dependencies: dependencies
        )
    }
    
    
}
