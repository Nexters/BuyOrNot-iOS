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
                .foregroundColor(BNColor(.type(.gray200)).color)

            VStack(spacing: 6) {
                Text("아직 올린 투표가 없어요")
                    .font(BNFont.font(.t1b))
                    .foregroundColor(BNColor(.type(.gray800)).color)

                Text("투표에 참여하고 소식을 받아보세요!")
                    .font(BNFont.font(.b5m))
                    .foregroundColor(BNColor(.type(.gray600)).color)
            }
        }
        .frame(maxWidth: .infinity)
    }
}


#Preview {
    let _ = BNFont.loadFonts()
    FeedEmptyView()
}
