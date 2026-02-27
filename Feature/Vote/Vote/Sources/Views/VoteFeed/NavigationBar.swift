//
//  NavigationBar.swift
//  Vote
//
//  Created by 이조은 on 2/11/26.
//

import SwiftUI
import DesignSystem

struct NavigationBar: View {
    let onNotificationTap: () -> Void
    let onProfileTap: () -> Void

    var body: some View {
        HStack {
            BNImage(.logo)
                .resizable()
                .scaledToFit()
                .frame(width: 82)
                .padding(.leading, 2)

            Spacer()

            HStack(spacing: 24) {
                Button {
                    onNotificationTap()
                } label: {
                    BNImage(.notification_fill)
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(BNColor(.type(.gray500)).color)
                }

                Button {
                    onProfileTap()
                } label: {
                    BNImage(.my)
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(BNColor(.type(.gray500)).color)
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 20)
    }
}
