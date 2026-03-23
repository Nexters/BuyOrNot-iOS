//
//  AlramEmptyView.swift
//  Vote
//
//  Created by 이조은 on 2/13/26.
//

import SwiftUI
import DesignSystem

struct AlarmEmptyView: View {
    var body: some View {
        VStack(spacing: 16) {
            BNImage(.notification_empty_image)
                .resizable()
                .scaledToFit()
                .frame(width: 140, height: 140)
                .foregroundColor(ColorPalette.gray200)

            VStack(spacing: 6) {
                BNText("새로운 알림이 없어요")
                    .style(style: .t1b, color: .gray800)

                BNText("투표에 참여하고 소식을 받아보세요!")
                    .style(style: .b5m, color: .gray600)
            }
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    let _ = BNFont.loadFonts()
    AlarmEmptyView()
}
