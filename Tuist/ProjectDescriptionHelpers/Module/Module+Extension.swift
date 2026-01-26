//
//  Module+Extension.swift
//  Manifests
//
//  Created by 문종식 on 1/26/26.
//

import ProjectDescription

// MARK: - Module
extension Module: ModuleProject {
    var moduleName: String {
        self.rawValue
    }

    var projectPath: Path {
        Path(stringLiteral: moduleName)
    }
    
    public static var projects: [Path] {
        allCases.map(\.projectPath) + Feature.allCases.compactMap(\.projectPath)
    }
    
    var product: ProjectDescription.Product {
        switch self {
        case .app: .app
        default: .staticFramework
        }
    }
}

// MARK: - Module.Feature
extension Module.Feature: ModuleProject {
    var moduleName: String {
        self.rawValue
    }
    
    var projectPath: Path {
        Path(stringLiteral: "Feature/\(moduleName)")
    }
    
    var product: ProjectDescription.Product {
        .staticFramework
    }
}
