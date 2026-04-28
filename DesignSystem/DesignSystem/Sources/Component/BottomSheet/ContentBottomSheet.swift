//
//  ContentBottomSheet.swift
//  DesignSystem
//
//  Created by 문종식 on 4/28/26.
//

import SwiftUI

public struct ContentBottomSheetModifier<SheetView: View>: ViewModifier {
    @Binding private var isPresented: Bool
    private let isEnableDismiss: Bool
    private let handleBottomSpacing: CGFloat
    private let child: (@escaping VoidCallBack) -> SheetView

    public init(
        isPresented: Binding<Bool>,
        isEnableDismiss: Bool = true,
        handleBottomSpacing: CGFloat = 26,
        @ViewBuilder child: @escaping (@escaping VoidCallBack) -> SheetView
    ) {
        self._isPresented = isPresented
        self.isEnableDismiss = isEnableDismiss
        self.handleBottomSpacing = handleBottomSpacing
        self.child = child
    }

    public func body(content: Content) -> some View {
        content
            .bnBottomSheet(
                isPresented: $isPresented,
                isEnableDismiss: isEnableDismiss,
                handleBottomSpacing: handleBottomSpacing,
                child: child
            )
    }
}

public extension View {
    func contentBottomSheet<SheetContent: View>(
        isPresented: Binding<Bool>,
        isEnableDismiss: Bool = true,
        handleBottomSpacing: CGFloat = 26,
        @ViewBuilder child: @escaping (@escaping VoidCallBack) -> SheetContent
    ) -> some View {
        modifier(
            ContentBottomSheetModifier(
                isPresented: isPresented,
                isEnableDismiss: isEnableDismiss,
                handleBottomSpacing: handleBottomSpacing,
                child: child
            )
        )
    }
}
