//
//  ModuleTarget.swift
//  Manifests
//
//  Created by 문종식 on 1/25/26.
//

import ProjectDescription

private let bundleID = "com.sseotdabwa.buyornot"

public protocol ModuleTarget: ModuleName {
    func target(dependencies: [TargetDependency]) -> Target
    var product: Product { get }
}

public extension ModuleTarget {
    func target(dependencies: [TargetDependency]) -> Target {
        .target(
            name: moduleName,
            destinations: .iOS,
            product: product,
            bundleId: "\(bundleID)\(product == .staticFramework ? "." : "")\(moduleName.lowercased())",
            deploymentTargets: .iOS("18.0"),
            infoPlist: .default,
            sources: ["\(moduleName)/Sources/**"],
            resources: ["\(moduleName)/Resources/**"],
            dependencies: dependencies
        )
    }
    
    
}
