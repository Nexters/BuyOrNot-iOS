//
//  Project.swift
//  Manifests
//
//  Created by 문종식 on 1/18/26.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Module.app.project(
    dependencies: [
        Module.Feature.login.toDependency,
        Module.Feature.createVote.toDependency,
        Module.Feature.myPage.toDependency,
        .external(name: "Swinject"),
    ],
    infoPlist: .extendingDefault(
        with: [
            "UISupportedInterfaceOrientations": [
                "UIInterfaceOrientationPortrait",
            ],
            "UISupportedInterfaceOrientations~ipad": [
                "UIInterfaceOrientationPortrait",
            ],
            "UILaunchScreen": .dictionary(
                ["UILaunchScreen": .dictionary([:])]
            ),
            "UILaunchStoryboardName": "LaunchScreen",
            "CFBundleDisplayName":
                "살까말까",
            "UIUserInterfaceStyle":
                "Light",
            "NSPhotoLibraryAddUsageDescription":
                "투표 등록 시 사진을 등록하기 위해서 앨범 접근 권한이 필요합니다.",
            "NSPhotoLibraryUsageDescription":
                "투표 등록 시 사진을 등록하기 위해서 앨범 접근 권한이 필요합니다.",
        ]
    ),
    entitlements: "App/App.entitlements",
)
