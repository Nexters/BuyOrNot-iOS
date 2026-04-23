//
//  CategoryEmptyView.swift
//  Vote
//
//  Created by 이조은 on 4/23/26.
//

import SwiftUI
import DesignSystem

struct CategoryEmptyView: View {
    let onCreateVote: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            BNImage(.category_empty_image)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity)

            BNText("첫번째 투표를 올려보세요!")
                .style(style: .t1b, color: ColorPalette.gray800)
                .padding(.top, 10)

            BNButton(
                text: "투표 등록하기",
                type: .secondarySmall,
                state: .enabled,
                action: onCreateVote
            )
            .fixedSize()
            .padding(.top, 20)
        }
        .padding(.horizontal, 20)
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    let _ = BNFont.loadFonts()
    CategoryEmptyView(onCreateVote: { print("create vote tapped") })
}
