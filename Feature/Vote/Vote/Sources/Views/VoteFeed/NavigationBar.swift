//
//  NavigationBar.swift
//  Vote
//
//  Created by 이조은 on 2/11/26.
//

import SwiftUI
import DesignSystem

struct NavigationBar: View {
    let isGuest: Bool
    let notificationCount: Int
    let onNotificationTap: () -> Void
    let onProfileTap: () -> Void
    let onLoginTap: () -> Void
    
    init(
        isGuest: Bool,
        notificationCount: Int = 0,
        onNotificationTap: @escaping () -> Void,
        onProfileTap: @escaping () -> Void,
        onLoginTap: @escaping () -> Void
    ) {
        self.isGuest = isGuest
        self.notificationCount = notificationCount
        self.onNotificationTap = onNotificationTap
        self.onProfileTap = onProfileTap
        self.onLoginTap = onLoginTap
    }

    var body: some View {
        HStack {
            BNImage(.logo)
                .resizable()
                .scaledToFit()
                .frame(width: 82)
                .padding(.leading, 2)

            Spacer()

            if isGuest {
                Button {
                    onLoginTap()
                } label: {
                    BNText("로그인/회원가입")
                        .style(style: .s5sb, color: ColorPalette.gray800)
                }
                .frame(width: 108, height: 40)
                .background(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(ColorPalette.gray300, lineWidth: 1)
                )
                .cornerRadius(10)
            } else {
                HStack(spacing: 0) {
                    Button {
                        onNotificationTap()
                    } label: {
                        BNImage(.notification_fill)
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(ColorPalette.gray500)
                            .padding(10)
                    }
                    .overlay(alignment: .bottomLeading) {
                        if notificationCount > 0 {
                            NotificationBadge(count: notificationCount)
                                .offset(x: 18, y: -20)
                        }
                    }

                    Button {
                        onProfileTap()
                    } label: {
                        BNImage(.my)
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(ColorPalette.gray500)
                            .padding(10)
                    }
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 20)
    }
}
