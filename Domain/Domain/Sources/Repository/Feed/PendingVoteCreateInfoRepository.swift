//
//  PendingVoteCreateInfoRepository.swift
//  Domain
//
//  Created by Codex on 3/15/26.
//

public protocol PendingVoteCreateInfoRepository {
    func savePendingVoteCreateInfo(_ info: PendingVoteCreateInfo)
    func getPendingVoteCreateInfo() -> PendingVoteCreateInfo?
    func removePendingVoteCreateInfo()
}
