//
//  Project.swift
//  Manifests
//
//  Created by 문종식 on 1/18/26.
//

import ProjectDescription
import ProjectDescriptionHelpers

let version = "0.0.8"
let build = 0

let project = Module.app.project(
    dependencies: [
        Module.Feature.splash.toDependency,
        Module.Feature.auth.toDependency,
        Module.Feature.vote.toDependency,
        Module.service.toDependency,
        .external(name: "Swinject"),
        .external(name: "KakaoSDKAuth"),
        .external(name: "FirebaseMessaging"),
        .external(name: "FirebaseRemoteConfig"),
    ],
    infoPlist: .extendingDefault(
        
        with: getAppInfoPlistValues()
    ),
    entitlements: "App/App.entitlements",
    settings: .settings(
        base: [
            "INFOPLIST_KEY_CFBundleDisplayName": "살까말까",
            "OTHER_LDFLAGS": ["$(inherited)", "-ObjC"],
            "MARKETING_VERSION": .string(version),
            "CURRENT_PROJECT_VERSION": .string(build.description),
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

private func getAppInfoPlistValues() -> [String: Plist.Value] {
    var values: [String: Plist.Value] = [
        "CFBundleShortVersionString": .string(version),
        "CFBundleVersion": .string(build.description),
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
        "NSCameraUsageDescription":
            "투표 등록 시 사진을 촬영하기 위해서 카메라 접근 권한이 필요합니다.",
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
    
    let xcconfigInfo: [String: Plist.Value] = [
        "CLIENT_ID":
            "$(CLIENT_ID)",
        "REVERSED_CLIENT_ID":
            "$(REVERSED_CLIENT_ID)",
        "BUNDLE_ID":
            "$(BUNDLE_ID)",
        "KAKAO_NATIVE_APP_KEY":
            "$(KAKAO_NATIVE_APP_KEY)",
        "BASE_URL":
            "$(BASE_URL)",
        "DEV_BASE_URL":
            "$(DEV_BASE_URL)",
        "SERVICE_TERMS_URL":
            "$(SERVICE_TERMS_URL)",
        "PRIVACY_POLICY_URL":
            "$(PRIVACY_POLICY_URL)",
        "USER_FEEDBACK_URL":
            "$(USER_FEEDBACK_URL)",
        "APP_STORE_URL":
            "$(APP_STORE_URL)",
    ]

    for (key, value) in xcconfigInfo {
        values[key] = value
    }
    return values
}
