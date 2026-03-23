//
//  CategorySheetView.swift
//  CreateVote
//
//  Created by 문종식 on 2/4/26.
//

import SwiftUI
import DesignSystem
import Domain

struct CategorySheetView: View {
    let category: [FeedCategory]
    let selectedCategory: FeedCategory?
    let didTapCategory: (FeedCategory) -> Void
    
    init(
        _ category: [FeedCategory],
        _ selectedCategory: FeedCategory?,
        _ didTapCategory: @escaping (FeedCategory) -> Void
    ) {
        self.category = category
        self.selectedCategory = selectedCategory
        self.didTapCategory = didTapCategory
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            BNText("카테고리")
                .style(style: .s1sb, color: ColorPalette.gray900)
            
            ZStack {
                ScrollView {
                    LazyVStack {
                        ForEach(category, id: \.self) { item in
                            Button {
                                didTapCategory(item)
                            } label: {
                                HStack {
                                    BNText(item.displayName)
                                        .style(
                                            style: item == selectedCategory ? .s3sb : .b3m,
                                            color: item == selectedCategory ? ColorPalette.gray900 : ColorPalette.gray700
                                        )
                                    Spacer()
                                    if item == selectedCategory {
                                        BNImage(.check)
                                            .style(color: ColorPalette.gray900, size: 20)
                                    }
                                }
                                .padding(.top, 10)
                                .padding(.bottom, 8)
                            }
                        }
                        Spacer(minLength: 70)
                    }
                }
                .scrollIndicators(.hidden)
                .defaultScrollAnchor(.top)
                
                VStack {
                    Spacer()
                    LinearGradient(
                        gradient: Gradient(colors: [
                            ColorPalette.gray0.opacity(0),
                            ColorPalette.gray0
                        ]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .frame(height: 70)
                }
            }
            .frame(height: 238)
        }
        .padding(.horizontal, 24)
    }
}


#Preview {
    let category = FeedCategory.allCases
    CategorySheetView(
        category,
        .travel
    ) { _ in }
}
