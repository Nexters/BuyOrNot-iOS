//
//  CategorySheetView.swift
//  CreateVote
//
//  Created by 문종식 on 2/4/26.
//

import SwiftUI
import DesignSystem

struct CategorySheetView: View {
    let category: [String]
    let selectedCategory: String?
    let didTapCategory: (String) -> Void
    
    init(
        _ category: [String],
        _ selectedCategory: String?,
        _ didTapCategory: @escaping (String) -> Void
    ) {
        self.category = category
        self.selectedCategory = selectedCategory
        self.didTapCategory = didTapCategory
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            BNText("카테고리")
                .style(style: .s1sb, color: .type(.gray900))
            
            ZStack {
                ScrollView {
                    LazyVStack {
                        ForEach(category, id: \.self) { item in
                            Button {
                                didTapCategory(item)
                            } label: {
                                HStack {
                                    BNText(item)
                                        .style(
                                            style: item == selectedCategory ? .s3sb : .b3m,
                                            color: .type(item == selectedCategory ? .gray900 : .gray700)
                                        )
                                    Spacer()
                                    if item == selectedCategory {
                                        BNImage(.check)
                                            .style(color: .type(.gray900), size: 20)
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
                            BNColor(.type(.gray0)).color.opacity(0),
                            BNColor(.type(.gray0)).color
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
    let category = [
        "명품∙프리미엄",
        "패션 ∙ 잡화",
        "화장품∙뷰티",
        "트렌드∙가성비템",
        "음식",
        "전자기기",
        "여행 쇼핑템",
        "헬스∙운동용품",
        "도서",
        "기타",
    ]
    CategorySheetView(
        category,
        "여행 쇼핑템"
    ) { _ in }
}
