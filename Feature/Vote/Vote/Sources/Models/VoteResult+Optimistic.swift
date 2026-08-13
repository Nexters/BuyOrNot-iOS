//
//  VoteResult+Optimistic.swift
//  Vote
//
//  Created by 문종식 on 8/11/26.
//

import Domain

extension VoteResult {
    func optimisticCounts(hadExistingVote: Bool) -> (yes: Int, no: Int) {
        guard hadExistingVote == false else {
            return (yes: yesCount, no: noCount)
        }

        switch choice {
        case .yes:
            return (yes: yesCount + 1, no: noCount)
        case .no:
            return (yes: yesCount, no: noCount + 1)
        }
    }
}
