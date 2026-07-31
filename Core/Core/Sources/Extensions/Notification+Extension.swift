//
//  Notification+Extension.swift
//  Core
//
//  Created by 문종식 on 3/29/26.
//

import Foundation

public extension Notification.Name {
    static let authSessionDidExpire = Notification.Name("authSessionDidExpire")
    static let analyticsUserIdDidChange = Notification.Name("analyticsUserIdDidChange")
    static let didReceiveRemotePushPayload = Notification.Name("didReceiveRemotePushPayload")
    static let didTapRemotePushPayload = Notification.Name("didTapRemotePushPayload")
    static let requestCreateVoteDismissForExternalNavigation = Notification.Name("requestCreateVoteDismissForExternalNavigation")
    static let cancelCreateVoteExternalNavigation = Notification.Name("cancelCreateVoteExternalNavigation")
}
