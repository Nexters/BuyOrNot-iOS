//
//  ModuleProject.swift
//  Manifests
//
//  Created by 문종식 on 1/25/26.
//

import ProjectDescription

public protocol ModuleName {
    var moduleName: String { get }
    var projectPath: Path { get }
}

