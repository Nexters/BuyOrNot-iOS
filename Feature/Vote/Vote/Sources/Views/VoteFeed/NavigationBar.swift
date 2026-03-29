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
    let onNotificationTap: () -> Void
    let onProfileTap: () -> Void
    let onLoginTap: () -> Void

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
                HStack(spacing: 24) {
                    Button {
                        onNotificationTap()
                    } label: {
                        BNImage(.notification_fill)
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(ColorPalette.gray500)
                    }

                    Button {
                        onProfileTap()
                    } label: {
                        BNImage(.my)
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(ColorPalette.gray500)
                    }
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 20)
    }
}
