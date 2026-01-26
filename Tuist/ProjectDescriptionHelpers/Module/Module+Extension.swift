//
//  Module+Extension.swift
//  Manifests
//
//  Created by 문종식 on 1/26/26.
//

import ProjectDescription

// MARK: - Module
extension Module: ModuleProject {
    public static var projects: [Path] {
        allCases.map(\.projectPath) + Feature.allCases.compactMap(\.projectPath)
    }
    
    public var moduleName: String {
        self.rawValue
    }

    public var projectPath: Path {
        Path(stringLiteral: moduleName)
    }
    
    public var product: ProjectDescription.Product {
        switch self {
        case .app: .app
        default: .staticFramework
        }
    }
}

// MARK: - Module.Feature
extension Module.Feature: ModuleProject {
    public var moduleName: String {
        self.rawValue
    }
    
    public var projectPath: Path {
        Path(stringLiteral: "Feature/\(moduleName)")
    }
    
    public var product: ProjectDescription.Product {
        .staticFramework
    }
}
