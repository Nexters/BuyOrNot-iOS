//
//  DeleteAccountView.swift
//  MyPage
//
//  Created by 문종식 on 2/7/26.
//

import SwiftUI
import DesignSystem

public struct DeleteAccountView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel = DeleteAccountViewModel()
    
    public init() {
        
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 20) {
                HStack {
                    BNText("\(viewModel.name)님,\n살까말까를 떠나시나요?")
                        .style(style: .h3b, color: .type(.gray900))
                    Spacer()
                }
                HStack {
                    BNText(viewModel.guide)
                        .style(style: .p1m, color: .type(.gray700))
                    Spacer()
                }
            }
            .padding(20)
            Spacer()
            BNButton(
                text: "탈퇴하기",
                type: .primary,
                state: .enabled
            ) {
                viewModel.didTapDeleteAccountButton()
            }
            .padding(20)
        }
        .bnAlert(
            isPresented: $viewModel.showDeleteAccountAlert,
            isEnableDismiss: true,
            config: BNAlertConfig(
                title: "정말 탈퇴하시겠어요?",
                buttons: [
                    BNAlertButtonConfig(
                        text: "탈퇴하기",
                        type: .secondaryLarge,
                    ) {
                        /// TODO: 작업 예정
                    },
                    BNAlertButtonConfig(
                        text: "유지하기",
                        type: .primary,
                    ) {
                        dismiss()
                    },
                ]
            )
        )
    }
}

#Preview {
    PolicyView()
}
