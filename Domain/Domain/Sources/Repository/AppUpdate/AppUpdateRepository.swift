//
//  AppUpdateRepository.swift
//  Domain
//
//  Created by 문종식 on 4/5/26.
//

public protocol AppUpdateRepository {
    func fetchAndActivate() async throws
    func getAppUpdateInfo() async -> AppUpdateInfo
    func shouldShowSoftUpdateToday() -> Bool
    func markSoftUpdateShown()
}
