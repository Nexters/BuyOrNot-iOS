//
//  OptionBottomSheet.swift
//  DesignSystem
//
//  Created by Codex on 4/28/26.
//

import SwiftUI

public struct OptionBottomSheetModifier<SheetView: View>: ViewModifier {
    @Binding private var isPresented: Bool
    private let isEnableDismiss: Bool
    private let child: (@escaping VoidCallBack) -> SheetView

    public init(
        isPresented: Binding<Bool>,
        isEnableDismiss: Bool = true,
        @ViewBuilder child: @escaping (@escaping VoidCallBack) -> SheetView
    ) {
        self._isPresented = isPresented
        self.isEnableDismiss = isEnableDismiss
        self.child = child
    }

    public func body(content: Content) -> some View {
        content
            .bnBottomSheet(
                isPresented: $isPresented,
                isEnableDismiss: isEnableDismiss,
                child: child
            )
    }
}

public extension View {
    func optionBottomSheet<SheetContent: View>(
        isPresented: Binding<Bool>,
        isEnableDismiss: Bool = true,
        @ViewBuilder child: @escaping (@escaping VoidCallBack) -> SheetContent
    ) -> some View {
        modifier(
            OptionBottomSheetModifier(
                isPresented: isPresented,
                isEnableDismiss: isEnableDismiss,
                child: child
            )
        )
    }
}
