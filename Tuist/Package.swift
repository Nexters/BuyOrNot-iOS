// swift-tools-version: 6.0
import PackageDescription

#if TUIST
import struct ProjectDescription.PackageSettings

let packageSettings = PackageSettings(
    // Customize the product types for specific package product
    // Default is .staticFramework
    // productTypes: ["Alamofire": .framework,]
    productTypes: [:]
)
#endif

let package = Package(
    name: "BuyOrNot",
    dependencies: [
        // Swinject
        .package(url: "https://github.com/Swinject/Swinject.git", from: "2.8.0"),
        // KakaoSDKCommon, KakaoSDKAuth, KakaoSDKUser
        .package(url: "https://github.com/kakao/kakao-ios-sdk.git", branch: "master"),
        // GoogleSignInSwift, GoogleSignIn
        .package(url: "https://github.com/google/GoogleSignIn-iOS", exact: "9.1.0"),
        .package(url: "https://github.com/firebase/firebase-ios-sdk", branch: "main"),
    ]
)
