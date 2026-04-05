//
//  UpdateStrategy.swift
//  Domain
//
//  Created by 문종식 on 4/5/26.
//

public enum UpdateStrategy {
    case force
    case soft
    case none

    public init(remoteValue: String) {
        switch remoteValue.trimmingCharacters(in: .whitespacesAndNewlines).uppercased() {
        case "FORCE":
            self = .force
        case "SOFT":
            self = .soft
        default:
            self = .none
        }
    }
}
