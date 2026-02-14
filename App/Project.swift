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
        Module.Feature.auth.toDependency,
        Module.Feature.vote.toDependency,
        Module.service.toDependency,
        .external(name: "Swinject"),
        .external(name: "KakaoSDKAuth"),
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
            "CLIENT_ID":
                "$(CLIENT_ID)",
            "REVERSED_CLIENT_ID":
                "$(REVERSED_CLIENT_ID)",
            "BUNDLE_ID":
                "$(BUNDLE_ID)",
            "KAKAO_NATIVE_APP_KEY":
                "$(KAKAO_NATIVE_APP_KEY)",
            "LSApplicationQueriesSchemes": .array([
                "kakaokompassauth",
                "kakaolink",
                "kakaoplus",
                "kakaotalk",
            ]),
            "CFBundleURLTypes": .array([
                .dictionary([
                    "CFBundleURLSchemes": .array([
                        .string("kakao$KAKAO_NATIVE_APP_KEY"),
                    ]),
                ]),
                .dictionary([
                    "CFBundleURLSchemes": .array([
                        .string("$REVERSED_CLIENT_ID"),
                    ]),
                ]),
            ]),
        ]
    ),
    entitlements: "App/App.entitlements",
    settings: .settings(
        base: [
            "OTHER_LDFLAGS": ["$(inherited)", "-ObjC"]
        ],
        configurations: [
            .debug(
                name: .debug,
                xcconfig: .relativeToManifest("Config/Debug.xcconfig")
            ),
            .release(
                name: .release,
                xcconfig: .relativeToManifest("Config/Release.xcconfig")
            ),
        ]
    ),
)
