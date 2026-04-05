//
//  AppVersion.swift
//  Domain
//
//  Created by 문종식 on 4/5/26.
//

public struct AppVersion {
    public let major: Int
    public let minor: Int
    public let patch: Int
    
    public init(major: Int, minor: Int, patch: Int) {
        self.major = major
        self.minor = minor
        self.patch = patch
    }
    
    // "M.m.b" 형태 문자열 파싱
    // 실패 시 0.0.0을 반환합니다.
    public init(rawValue: String) {
        let components = rawValue.split(separator: ".", omittingEmptySubsequences: false)
        guard
            components.count == 3,
            let major = Int(components[0]),
            let minor = Int(components[1]),
            let patch = Int(components[2])
        else {
            self.init(major: 0, minor: 0, patch: 0)
            return
        }

        self.init(major: major, minor: minor, patch: patch)
    }
}

extension AppVersion: Comparable {
    public static func < (lhs: AppVersion, rhs: AppVersion) -> Bool {
        if lhs.major != rhs.major { return lhs.major < rhs.major }
        if lhs.minor != rhs.minor { return lhs.minor < rhs.minor }
        return lhs.patch < rhs.patch
    }
}
