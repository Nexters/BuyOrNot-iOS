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
    
    init(
        _ category: [String],
        _ selectedCategory: String?
    ) {
        self.category = category
        self.selectedCategory = selectedCategory
    }
    
    var body: some View {
        VStack(
            alignment: .leading,
            spacing: 10
        ) {
            BNText("카테고리")
                .style(style: .s1sb, color: .type(.gray900))
            ZStack {
                ScrollView {
                    LazyVStack {
                        ForEach(category, id: \.self) { item in
                            Button {
                                
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
                                            .style(
                                                color: .type(.gray900),
                                                size: 20
                                            )
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
                
                VStack {
                    Spacer()
                    LinearGradient(
                          gradient: Gradient(
                            colors: [
                                BNColor(.type(.gray0)).color.opacity(0),
                                BNColor(.type(.gray0)).color
                            ]
                          ),
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
    CategorySheetView(
        "abcdefghijklmnop".map { c in
            String(repeating: c, count: 10)
        },
        String(repeating: "b", count: 10)
    )
}
