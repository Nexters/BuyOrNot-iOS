//
//  VoteDestination.swift
//  App
//
//  Created by 문종식 on 2/22/26.
//

enum VoteDestination: Hashable {
    case notification
    case myPage
    case feedDetail(feedId: Int)
}
