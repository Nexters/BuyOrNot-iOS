//
//  ActionBottomSheet.swift
//  DesignSystem
//
//  Created by 문종식 on 4/28/26.
//

import SwiftUI

public struct ActionBottomSheetItem<T> {
    public let item: T
    public let icon: BNImageAsset?
    public let text: String
    public let action: (T) -> Void

    public init(
        item: T,
        icon: BNImageAsset? = nil,
        text: String,
        action: @escaping (T) -> Void
    ) {
        self.item = item
        self.icon = icon
        self.text = text
        self.action = action
    }
}

public struct ActionBottomSheetModifier<ActionType>: ViewModifier {
    @Binding private var isPresented: Bool
    private let isEnableDismiss: Bool
    private let handleBottomSpacing: CGFloat
    private let items: [ActionBottomSheetItem<ActionType>]

    public init(
        isPresented: Binding<Bool>,
        isEnableDismiss: Bool = true,
        handleBottomSpacing: CGFloat = 26,
        items: [ActionBottomSheetItem<ActionType>]
    ) {
        self._isPresented = isPresented
        self.isEnableDismiss = isEnableDismiss
        self.handleBottomSpacing = handleBottomSpacing
        self.items = items
    }

    public func body(content: Content) -> some View {
        content
            .bnBottomSheet(
                isPresented: $isPresented,
                isEnableDismiss: isEnableDismiss,
                handleBottomSpacing: handleBottomSpacing,
                child: { dismiss in
                    actionBottomSheetContent(dismiss: dismiss)
                }
            )
    }

    @ViewBuilder
    private func actionBottomSheetContent(dismiss: @escaping VoidCallBack) -> some View {
        VStack(spacing: 18) {
            ForEach(Array(items.enumerated()), id: \.offset) { _, item in
                Button {
                    dismiss()
                    item.action(item.item)
                } label: {
                    HStack(spacing: 10) {
                        if let icon = item.icon {
                            BNImage(icon)
                                .style(color: ColorPalette.gray900, size: 20)
                        }
                        BNText(item.text)
                            .style(style: .s3sb, color: ColorPalette.gray900)
                            .padding(.vertical, 6)
                        Spacer()
                    }
                }
            }
        }
        .padding(.top, 6)
        .padding(.horizontal, 24)
        .padding(.bottom, 30)
    }
}

public extension View {
    func actionBottomSheet<ActionType>(
        isPresented: Binding<Bool>,
        isEnableDismiss: Bool = true,
        handleBottomSpacing: CGFloat = 26,
        items: [ActionBottomSheetItem<ActionType>]
    ) -> some View {
        modifier(
            ActionBottomSheetModifier(
                isPresented: isPresented,
                isEnableDismiss: isEnableDismiss,
                handleBottomSpacing: handleBottomSpacing,
                items: items
            )
        )
    }
}
