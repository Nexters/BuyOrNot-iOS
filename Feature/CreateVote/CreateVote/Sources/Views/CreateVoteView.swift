//
//  PlaceHolder.swift
//  Manifests
//
//  Created by 문종식 on 1/18/26.
//

import SwiftUI
import DesignSystem

public struct CreateVoteView: View {
    @State private var price: String = "10000000"
    @State private var text: String = "ㄱㄱㄱㄱㄱㄱㄱ"
    
    public var body: some View {
        VStack(spacing: 0) {
            HStack {
                cancel()
                    .padding(.bottom, 14)
                Spacer()
            }
            .padding(.horizontal, 20)
            BNDivider(size: .s)
            VStack(spacing: 0) {
                category("음식")
                    .padding(.vertical, 18)
                BNDivider(size: .s)
                price(text: $price)
                BNDivider(size: .s)
                VoteTextField(text: $text)
                HStack {
                    addPhoto()
                    Spacer()
                }
                Spacer()
                HStack {
                    Spacer()
                    BNButton(
                        text: "투표 게시!",
                        type: .capsule,
                        state: .enabled,
                        width: 80
                    ) {
                        
                    }
                }
            }
            .padding(.horizontal, 20)
        }
        .padding(.top, 20)
        .padding(.bottom, 10)
    }
    
    @ViewBuilder
    private func cancel() -> some View {
        Button {
            
        } label: {
            BNText("취소")
                .style(style: .s4sb, color: .type(.gray700))
        }
    }
    
    @ViewBuilder
    private func category(_ text: String?) -> some View {
        HStack(spacing: 8) {
            BNText("투표 등록")
                .style(style: .s3sb, color: .type(.gray800))
            BNImage(.right)
                .style(color: .type(.gray600), size: 14)
            if let text {
                BNText(text)
                    .style(style: .s3sb, color: .type(.gray800))
            } else {
                BNText("카테고리 추가")
                    .style(style: .s3sb, color: .type(.gray600))
            }
            Spacer()
        }
    }
    
    @ViewBuilder
    private func price(text: Binding<String>) -> some View {
        HStack(spacing: 6) {
            BNImage(.won)
                .style(color: .type(.gray600), size: 18)
            TextField(text: text) {
                BNText("상품 가격을 입력해주세요.")
                    .style(style: .s3sb, color: .type(.gray600))
            }
            .keyboardType(.numberPad)
            .font(BNFont.font(.s3sb))
            .foregroundStyle(BNColor(.type(.gray800)).color)
            .tint(BNColor(.type(.gray900)).color)
            Spacer()
        }
        .padding(.vertical, 18)
    }
    
    @ViewBuilder
    private func addPhoto() -> some View {
        VStack(spacing: 2) {
            BNImage(.camera)
                .style(color: .type(.gray600), size: 20)
            BNText("0/1")
                .style(style: .s5sb, color: .type(.gray600))
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 15)
        .background {
            RoundedRectangle(cornerRadius: 12)
                .fill(BNColor(.type(.gray100)).color)
        }
    }
}

#Preview {
    CreateVoteView()
}
