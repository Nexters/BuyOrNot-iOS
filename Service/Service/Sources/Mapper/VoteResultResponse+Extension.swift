//
//  VoteResultResponse+Extension.swift
//  Service
//
//  Created by 이조은 on 2/21/26.
//

import Domain

extension VoteResultResponse {
    func toDomain() -> VoteResult? {
        guard let choice = VoteChoice(rawValue: self.choice) else { return nil }
        return VoteResult(
            feedId: self.feedId,
            choice: choice,
            yesCount: self.yesCount,
            noCount: self.noCount,
            totalCount: self.totalCount
        )
    }
}
