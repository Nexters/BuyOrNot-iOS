//
//  VoteTextField.swift
//  CreateVote
//
//  Created by 문종식 on 2/2/26.
//

import SwiftUI
import DesignSystem

struct VoteTextField: View {
    @Binding var text: String
    let placeHolder: String = "고민 이유를 자세히 적을수록 더 정확한 투표 결과를 얻을 수 있어요!"
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                if text.isEmpty {
                    VStack {
                        HStack {
                            BNText(placeHolder)
                                .style(style: .p2m, color: .type(.gray600))
                            Spacer()
                        }
                        Spacer()
                    }
                }
                
                TextField(
                    text: $text,
                    axis: .vertical
                ) {
                    
                }
                .font(BNFont.font(.p2m))
                .foregroundStyle(BNColor(.type(.gray900)).color)
                .tint(BNColor(.type(.gray900)).color)
                .lineLimit(nil)
                .scrollContentBackground(.hidden)
                .background(.clear)
                .frame(height: 84, alignment: .topLeading)
                .onChange(of: text) {
                    
                }
            }
            .frame(height: 84)
            
            HStack {
                Spacer()
                BNText("\(text.count)/100")
                    .style(style: .c1m, color: .type(.gray600))
            }
            .padding(.vertical, 10)
        }

        .padding(.top, 20)
    }
}

