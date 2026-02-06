//
//  BNBottomSheet.swift
//  DesignSystem
//
//  Created by 문종식 on 2/4/26.
//

import SwiftUI

public struct BNBottomSheetModifier<SheetView: View>: ViewModifier {
    @Binding private var isPresented: Bool
    @State private var dragOffset: CGFloat = 0
    @State private var isFullScreenViewVisible = false
    private let isEnableDismiss: Bool
    private let sheetContent: (@escaping VoidCallBack) -> SheetView
    
    public init(
        isPresented: Binding<Bool>,
        isEnableDismiss: Bool,
        @ViewBuilder content: @escaping (@escaping VoidCallBack) -> SheetView
    ) {
        self._isPresented = isPresented
        self.isEnableDismiss = isEnableDismiss
        self.sheetContent = content
    }
    
    private let hiddenOffset: CGFloat = UIScreen.main.bounds.height
    private let animation: Animation = .spring(
        response: 0.3,
        dampingFraction: 1
    )
    
    public func body(content: Content) -> some View {
        content
            .fullScreenCover(isPresented: $isPresented) {
                Group{
                    ZStack {
                        ZStack(alignment: .bottom) {
                            dimView
                                .opacity(isFullScreenViewVisible ? 1 : 0)
                            
                            sheetView
                                .offset(y: isFullScreenViewVisible ? max(dragOffset, 0) : hiddenOffset)
                                .gesture(dragGesture)
                        }
                    }
                    .onChange(of: isFullScreenViewVisible) { oldValue, newValue in
                        if !newValue {
                            dragOffset = 0
                        }
                    }
                    .animation(
                        animation,
                        value: isFullScreenViewVisible
                    )
                }
                .clearBackground()
                .onAppear {
                    isFullScreenViewVisible = true
                }
            }
            .transaction { transaction in
                transaction.disablesAnimations = isPresented
            }
            .animation(animation, value: isFullScreenViewVisible)
    }
    
    private var dimView: some View {
        Color
            .bnType(.gray1000)
            .opacity(0.5)
            .ignoresSafeArea()
            .onTapGesture {
                guard isEnableDismiss else { return }
                dismiss()
            }
    }
    
    @ViewBuilder
    private var sheetView: some View {
        VStack(spacing: 0) {
            handleView
                .padding(.top, 10)
                .padding(.bottom, 16)
            sheetContent(dismiss)
        }
        .frame(maxWidth: .infinity)
        .background(.bnType(.gray0))
        .clipShape(
            RoundedRectangle(
                cornerRadius: 26,
                style: .continuous
            )
        )
        .padding(.horizontal, 14)
        .padding(.bottom, 10)
        .animation(.linear(duration: 0.2), value: dragOffset)
    }
    
    @ViewBuilder
    private var handleView: some View {
        Capsule()
            .fill(isEnableDismiss ? .hex("#D9D9D9"): .bnType(.gray0))
            .frame(width: 40, height: 4)
    }
    
    private var dragGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                guard isEnableDismiss else { return }
                let translation = value.translation.height
                dragOffset = translation
            }
            .onEnded { value in
                guard isEnableDismiss else { return }
                let translation = value.translation.height
                if translation > 100 {
                    dismiss()
                } else {
                    withAnimation(animation) {
                        dragOffset = 0
                    }
                }
            }
    }
    
    private func dismiss() {
        withAnimation(animation) {
            isFullScreenViewVisible = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                isPresented = false
            }
        }
    }
}

public extension View {
    func bnBottomSheet<SheetContent: View>(
        isPresented: Binding<Bool>,
        isEnableDismiss: Bool = true,
        @ViewBuilder content: @escaping (@escaping VoidCallBack) -> SheetContent
    ) -> some View {
        modifier(
            BNBottomSheetModifier(
                isPresented: isPresented,
                isEnableDismiss: isEnableDismiss,
                content: content
            )
        )
    }
}
