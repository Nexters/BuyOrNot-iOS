//
//  FeedErrorView.swift
//  Vote
//
//  Created by 이조은 on 2/11/26.
//

import SwiftUI
import DesignSystem

struct FeedErrorView: View {
    let onRetry: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            BNImage(.error_image)
                .resizable()
                .scaledToFit()
                .frame(width: 140, height: 140)
                .foregroundColor(ColorPalette.gray200)

            BNText("내용을 불러오지 못했어요")
                .style(style: .t1b, color: ColorPalette.gray800)
                .padding(.bottom, 4)

            BNButton(
                text: "새로고침",
                type: .secondarySmall,
                state: .enabled,
                width: 69
            ) {
                onRetry()
            }
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    let _ = BNFont.loadFonts()
    FeedErrorView(onRetry: { } )
}
