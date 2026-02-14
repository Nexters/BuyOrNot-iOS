//
//  Project.swift
//  Manifests
//
//  Created by 문종식 on 1/18/26.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Module.Feature.auth.project(
    dependencies: [
        Module.core.toDependency,
        Module.domain.toDependency,
        Module.designSystem.toDependency,
        .external(name: "GoogleSignIn"),
        .external(name: "GoogleSignInSwift"),
        .external(name: "KakaoSDKCommon"),
        .external(name: "KakaoSDKAuth"),
        .external(name: "KakaoSDKUser"),
        .external(name: "FirebaseMessaging"),
    ],
//    infoPlist: .extendingDefault(
//        with: [
//            "CLIENT_ID":
//                "$(CLIENT_ID)",
//            "REVERSED_CLIENT_ID":
//                "$(REVERSED_CLIENT_ID)",
//            "BUNDLE_ID":
//                "$(BUNDLE_ID)",
//            "KAKAO_NATIVE_APP_KEY":
//                "$(KAKAO_NATIVE_APP_KEY)",
//        ]
//    ),
    settings: .settings(
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
