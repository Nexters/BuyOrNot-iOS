//
//  Constants.swift
//  Core
//
//  Created by 문종식 on 2/13/26.
//

import Foundation

public struct Constants {
    public enum ConstantsKey: String {
        case serviceTermsURL = "SERVICE_TERMS_URL"
        case privacyPolicyURL = "PRIVACY_POLICY_URL"
        case userFeedbackURL = "USER_FEEDBACK_URL"
    }
    
    public static func getValue(with key: ConstantsKey) -> String {
        let bundleObject = Bundle.main.object(
            forInfoDictionaryKey: key.rawValue
        )
        return (bundleObject as? String) ?? ""
    }
}
