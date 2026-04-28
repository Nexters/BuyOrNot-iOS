//
//  ContentBottomSheet.swift
//  DesignSystem
//
//  Created by 문종식 on 4/28/26.
//

import SwiftUI

public struct ContentBottomSheetModifier: ViewModifier {
    @Binding private var isPresented: Bool
    private let isEnableDismiss: Bool
    private let icon: BNImageAsset
    private let title: String
    private let subTitle: String
    private let primaryButtonText: String
    private let secondaryButtonText: String
    private let didTapPrimaryButton: () -> Void
    private let didTapSecondaryButton: () -> Void
    private let customContent: AnyView?

    public init(
        isPresented: Binding<Bool>,
        isEnableDismiss: Bool = true,
        icon: BNImageAsset,
        title: String,
        subTitle: String,
        primaryButtonText: String,
        secondaryButtonText: String,
        didTapPrimaryButton: @escaping () -> Void,
        didTapSecondaryButton: @escaping () -> Void,
        customContent: AnyView? = nil
    ) {
        self._isPresented = isPresented
        self.isEnableDismiss = isEnableDismiss
        self.icon = icon
        self.title = title
        self.subTitle = subTitle
        self.primaryButtonText = primaryButtonText
        self.secondaryButtonText = secondaryButtonText
        self.didTapPrimaryButton = didTapPrimaryButton
        self.didTapSecondaryButton = didTapSecondaryButton
        self.customContent = customContent
    }

    public func body(content: Content) -> some View {
        content
            .bnBottomSheet(
                isPresented: $isPresented,
                isEnableDismiss: isEnableDismiss
            ) { dismiss in
                contentBottomSheetContent(dismiss: dismiss)
            }
    }

    @ViewBuilder
    private func contentBottomSheetContent(dismiss: @escaping VoidCallBack) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(ColorPalette.gray300)
                    .frame(width: 50, height: 50)
                    .overlay {
                        BNImage(icon)
                            .style(color: ColorPalette.gray950, size: 30)
                    }
                Spacer()
            }
            .padding(.horizontal, 6)

            VStack(alignment: .leading, spacing: 26) {
                VStack(alignment: .leading, spacing: 10) {
                    BNText(title)
                        .style(style: .s1sb, color: ColorPalette.gray950)
                    BNText(subTitle)
                        .style(style: .b4m, color: ColorPalette.gray700)
                }
                .padding(.horizontal, 6)

                if let customContent {
                    customContent
                        .padding(.horizontal, 6)
                }

                HStack(spacing: 10) {
                    BNButton(
                        text: primaryButtonText,
                        type: .primary,
                        state: .enabled
                    ) {
                        dismiss()
                        didTapPrimaryButton()
                    }
                    BNButton(
                        text: secondaryButtonText,
                        type: .secondaryLarge,
                        state: .enabled
                    ) {
                        dismiss()
                        didTapSecondaryButton()
                    }
                }
            }
        }
        .padding(.horizontal, 18)
        .padding(.bottom, 16)
    }
}

public extension View {
    func contentBottomSheet(
        isPresented: Binding<Bool>,
        isEnableDismiss: Bool = true,
        icon: BNImageAsset,
        title: String,
        subTitle: String,
        primaryButtonText: String,
        secondaryButtonText: String,
        didTapPrimaryButton: @escaping () -> Void,
        didTapSecondaryButton: @escaping () -> Void
    ) -> some View {
        modifier(
            ContentBottomSheetModifier(
                isPresented: isPresented,
                isEnableDismiss: isEnableDismiss,
                icon: icon,
                title: title,
                subTitle: subTitle,
                primaryButtonText: primaryButtonText,
                secondaryButtonText: secondaryButtonText,
                didTapPrimaryButton: didTapPrimaryButton,
                didTapSecondaryButton: didTapSecondaryButton
            )
        )
    }

    func contentBottomSheet<CustomContent: View>(
        isPresented: Binding<Bool>,
        isEnableDismiss: Bool = true,
        icon: BNImageAsset,
        title: String,
        subTitle: String,
        primaryButtonText: String,
        secondaryButtonText: String,
        didTapPrimaryButton: @escaping () -> Void,
        didTapSecondaryButton: @escaping () -> Void,
        @ViewBuilder customContent: @escaping () -> CustomContent
    ) -> some View {
        modifier(
            ContentBottomSheetModifier(
                isPresented: isPresented,
                isEnableDismiss: isEnableDismiss,
                icon: icon,
                title: title,
                subTitle: subTitle,
                primaryButtonText: primaryButtonText,
                secondaryButtonText: secondaryButtonText,
                didTapPrimaryButton: didTapPrimaryButton,
                didTapSecondaryButton: didTapSecondaryButton,
                customContent: AnyView(customContent())
            )
        )
    }
}
