//
//  AppUpdateInfo.swift
//  Splash
//
//  Created by 문종식 on 4/5/26.
//

public struct AppUpdateInfo {
    public let latestVersion: AppVersion
    public let minimumVersion: AppVersion
    public let updateStrategy: UpdateStrategy
    
    public init(latestVersion: AppVersion, minimumVersion: AppVersion, updateStrategy: UpdateStrategy) {
        self.latestVersion = latestVersion
        self.minimumVersion = minimumVersion
        self.updateStrategy = updateStrategy
    }
}
