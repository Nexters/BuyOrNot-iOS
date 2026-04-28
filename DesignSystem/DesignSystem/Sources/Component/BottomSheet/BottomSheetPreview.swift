//
//  BottomSheetPreview.swift
//  DesignSystem
//
//  Created by 문종식 on 4/28/26.
//

import SwiftUI

private struct BottomSheetPreviewContainer: View {
    @State private var showBasic = false
    @State private var showContent = false
    @State private var showOption = false
    @State private var showAction = false
    private let actionItems: [ActionBottomSheetItem<String>] = [
        .init(item: "camera", icon: .camera, text: "카메라로 직접 찍기") { _ in },
        .init(item: "album", icon: .photo_album, text: "앨범에서 사진 선택") { _ in },
        .init(item: "emtpy", text: "아이콘 없는 메뉴") { _ in }
    ]
    
    var body: some View {
        VStack(spacing: 12) {
            Button("Show Basic BottomSheet") { showBasic = true }
            Button("Show ContentBottomSheet") { showContent = true }
            Button("Show OptionBottomSheet") { showOption = true }
            Button("Show ActionBottomSheet") { showAction = true }
        }
        .bnBottomSheet(isPresented: $showBasic) { dismiss in
            previewChild(title: "Basic BottomSheet", dismiss: dismiss)
        }
        .contentBottomSheet(isPresented: $showContent) { dismiss in
            previewChild(title: "ContentBottomSheet", dismiss: dismiss)
        }
        .optionBottomSheet(isPresented: $showOption) { dismiss in
            previewChild(title: "OptionBottomSheet", dismiss: dismiss)
        }
        .actionBottomSheet(isPresented: $showAction, items: actionItems)
        .padding()
    }
    
    @ViewBuilder
    private func previewChild(title: String, dismiss: @escaping VoidCallBack) -> some View {
        VStack(spacing: 12) {
            BNText(title)
                .style(style: .s3sb, color: ColorPalette.gray800)
            BNButton(text: "닫기", type: .capsule, state: .enabled, width: 120) {
                dismiss()
            }
        }
        .padding(.bottom, 20)
    }
}

#Preview {
    BottomSheetPreviewContainer()
}
