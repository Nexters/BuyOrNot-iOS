//
//  VoteChoice.swift
//  Domain
//
//  Created by 이조은 on 2/21/26.
//

public enum VoteChoice {
    case yes
    case no

    public init?(rawValue: String) {
        switch rawValue {
        case "YES":
            self = .yes
        case "NO":
            self = .no
        default:
            return nil
        }
    }
}
