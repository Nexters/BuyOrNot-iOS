//
//  SocialAccount.swift
//  Domain
//
//  Created by 문종식 on 2/14/26.
//

public enum SocialAccount {
    case kakao
    case google
    case apple
    
    init?(rawValue: String) {
        switch rawValue {
        case "KAKAO":
            self = .kakao
        case "GOOGLE":
            self = .google
        case "APPLE":
            self = .apple
        default:
            return nil
        }
    }
}
