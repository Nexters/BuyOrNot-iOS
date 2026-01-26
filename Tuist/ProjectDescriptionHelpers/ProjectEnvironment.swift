//
//  ProjectEnvironment.swift
//  Manifests
//
//  Created by 문종식 on 1/26/26.
//

import ProjectDescription

public struct ProjectEnvironment {
    public static let deploymentTarget: DeploymentTargets = .iOS("18.0")
    public static let bundleIdPrefix = "com.sseotdabwa.buyornot"
}
