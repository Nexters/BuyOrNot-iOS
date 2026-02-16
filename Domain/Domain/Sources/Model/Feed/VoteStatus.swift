//
//  VoteStatus.swift
//  Domain
//
//  Created by 문종식 on 2/16/26.
//

public enum VoteStatus {
    case open
    case closed
    
    public init(rawValue: String) {
        switch rawValue {
        case "OPEN":
            self = .open
        case "CLOSED":
            self = .closed
        default:
            self = .closed
        }
    }
}

