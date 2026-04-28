//
//  BottomSheetPreview.swift
//  DesignSystem
//
//  Created by 문종식 on 4/28/26.
//

import SwiftUI

private enum OptionPreviewItem: String, CaseIterable, OptionBottomSheetDisplayable {
    case fashion = "패션"
    case digital = "디지털"
    case travel = "여행"
    case food = "식품"
    case hobby = "취미"
    case sports = "스포츠"

    var title: String { rawValue }
}

private struct BottomSheetPreviewContainer: View {
    @State private var showBasic = false
    @State private var showContentImageOnly = false
    @State private var showContentTextOnly = false
    @State private var showContentNone = false
    @State private var showOption = false
    @State private var showAction = false
    @State private var selectedOptionItem: OptionPreviewItem? = .travel
    private let actionItems: [ActionBottomSheetItem<String>] = [
        .init(item: "camera", icon: .camera, text: "카메라로 직접 찍기") { _ in },
        .init(item: "album", icon: .photo_album, text: "앨범에서 사진 선택") { _ in },
        .init(item: "emtpy", text: "아이콘 없는 메뉴") { _ in }
    ]
    private let optionItems: [OptionPreviewItem] = OptionPreviewItem.allCases
    
    var body: some View {
        VStack(spacing: 12) {
            Button("Show Basic BottomSheet") { showBasic = true }
            Button("Show ContentBottomSheet (Image)") { showContentImageOnly = true }
            Button("Show ContentBottomSheet (Text)") { showContentTextOnly = true }
            Button("Show ContentBottomSheet (None)") { showContentNone = true }
            Button("Show OptionBottomSheet") { showOption = true }
            Button("Show ActionBottomSheet") { showAction = true }
        }
        .bnBottomSheet(isPresented: $showBasic) { dismiss in
            previewChild(title: "Basic BottomSheet", dismiss: dismiss)
        }
        .contentBottomSheet(
            isPresented: $showContentImageOnly,
            icon: .notification,
            title: "알림 설정이 꺼져 있어요",
            subTitle: "푸시 알림을 켜면 투표 결과를 놓치지 않아요.",
            primaryButtonText: "설정 열기",
            secondaryButtonText: "닫기",
            didTapPrimaryButton: {},
            didTapSecondaryButton: {},
            customContent: {
                BNImage(.notification_fill)
                    .style(color: ColorPalette.gray950, size: 40)
            }
        )
        .contentBottomSheet(
            isPresented: $showContentTextOnly,
            icon: .notification,
            title: "알림 설정이 꺼져 있어요",
            subTitle: "푸시 알림을 켜면 투표 결과를 놓치지 않아요.",
            primaryButtonText: "설정 열기",
            secondaryButtonText: "닫기",
            didTapPrimaryButton: {},
            didTapSecondaryButton: {},
            customContent: {
                BNText("아무 텍스트")
                    .style(style: .b4m, color: ColorPalette.gray700)
            }
        )
        .contentBottomSheet(
            isPresented: $showContentNone,
            icon: .notification,
            title: "알림 설정이 꺼져 있어요",
            subTitle: "푸시 알림을 켜면 투표 결과를 놓치지 않아요.",
            primaryButtonText: "설정 열기",
            secondaryButtonText: "닫기",
            didTapPrimaryButton: {},
            didTapSecondaryButton: {}
        )
        .optionBottomSheet(
            isPresented: $showOption,
            title: "카테고리",
            selectedItem: selectedOptionItem,
            items: optionItems,
            didSelectItem: { item in
                selectedOptionItem = item
            }
        )
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
