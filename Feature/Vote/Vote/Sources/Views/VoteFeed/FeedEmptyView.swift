//
//  FeedEmptyView.swift
//  Vote
//
//  Created by 이조은 on 2/11/26.
//

import SwiftUI
import DesignSystem

struct FeedEmptyView: View {
    var body: some View {
        VStack(spacing: 16) {
            BNImage(.empty_image)
                .resizable()
                .scaledToFit()
                .frame(width: 140, height: 140)
                .foregroundColor(ColorPalette.gray200)

            VStack(spacing: 6) {
                BNText("아직 올린 투표가 없어요")
                    .style(style: .t1b, color: ColorPalette.gray800)

                BNText("고민되는 상품의 투표를 올려보세요!")
                    .style(style: .b5m, color: ColorPalette.gray600)
            }
        }
        .frame(maxWidth: .infinity)
    }
}


#Preview {
    let _ = BNFont.loadFonts()
    FeedEmptyView()
}
