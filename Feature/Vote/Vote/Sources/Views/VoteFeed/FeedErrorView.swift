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
                .foregroundColor(BNColor(.type(.gray200)).color)

            Text("내용을 불러오지 못했어요")
                .font(BNFont.font(.t1b))
                .foregroundColor(BNColor(.type(.gray800)).color)
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
