//
//  BNAlert.swift
//  DesignSystem
//
//  Created by 문종식 on 2/6/26.
//

import SwiftUI

public struct BNAlertModifier<AlertContent: View>: ViewModifier {
    @Binding private var isPresented: Bool
    @State private var isFullScreenViewVisible = false
    private let isEnableDismiss: Bool
    private let config: BNAlertConfig
    private let alertContent: () -> AlertContent
    
    private let animation: Animation = .spring(
        response: 0.2,
        dampingFraction: 1
    )
    
    public init(
        isPresented: Binding<Bool>,
        isEnableDismiss: Bool,
        config: BNAlertConfig,
        @ViewBuilder content: @escaping () -> AlertContent
    ) {
        self._isPresented = isPresented
        self.isEnableDismiss = isEnableDismiss
        self.config = config
        self.alertContent = content
    }
    
    public func body(content: Content) -> some View {
        content
            .fullScreenCover(isPresented: $isPresented) {
                Group {
                    ZStack {
                        dimView
                            .opacity(isFullScreenViewVisible ? 1 : 0)
                        alertBody(config: dismissingConfig)
                            .padding(.horizontal, 30)
                            .scaleEffect(isFullScreenViewVisible ? 1 : 0.96)
                            .opacity(isFullScreenViewVisible ? 1 : 0)
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
            .transaction{ transaction in
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
    private func alertBody(config: BNAlertConfig) -> some View {
        VStack(spacing: 26) {
            VStack(
                alignment: .leading,
                spacing: 10,
            ) {
                if let title = config.title {
                    HStack {
                        BNText(title)
                            .style(style: .s2sb, color: .type(.gray900))
                        Spacer()
                    }
                }
                if let message = config.message {
                    HStack {
                        BNText(message)
                            .style(style: .p2m, color: .type(.gray700))
                        Spacer()
                    }
                }
            }
            alertContent()
            buttonsView(config: config)
        }
        .padding(.top, 26)
        .padding(.horizontal, 18)
        .padding(.bottom, 16)
        .background(.bnType(.gray0))
        .clipShape(
            RoundedRectangle(
                cornerRadius: 24,
                style: .circular
            )
        )
    }
    
    @ViewBuilder
    private func buttonsView(config: BNAlertConfig) -> some View {
        if config.buttons.isEmpty {
            EmptyView()
        } else {
            HStack(spacing: 10) {
                ForEach(config.buttons) { button in
                    BNButton(
                        text: button.text,
                        type: button.type,
                        state: .enabled,
                    ) {
                        button.action()
                    }
                }
            }
        }
    }
    
    private var dismissingConfig: BNAlertConfig {
        BNAlertConfig(
            title: config.title,
            message: config.message,
            buttons: config.buttons.map { button in
                BNAlertButtonConfig(
                    text: button.text,
                    type: button.type
                ) {
                    dismiss()
                    button.action()
                }
            }
        )
    }
    
    private func dismiss() {
        withAnimation(animation) {
            isFullScreenViewVisible = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                isPresented = false
            }
        }
    }
}

public extension View {
    func bnAlert<AlertContent: View>(
        isPresented: Binding<Bool>,
        isEnableDismiss: Bool = true,
        config: BNAlertConfig,
        @ViewBuilder content: @escaping () -> AlertContent
    ) -> some View {
        modifier(
            BNAlertModifier(
                isPresented: isPresented,
                isEnableDismiss: isEnableDismiss,
                config: config,
                content: content
            )
        )
    }
    
    func bnAlert(
        isPresented: Binding<Bool>,
        isEnableDismiss: Bool = true,
        config: BNAlertConfig
    ) -> some View {
        modifier(
            BNAlertModifier(
                isPresented: isPresented,
                isEnableDismiss: isEnableDismiss,
                config: config
            ) {
                EmptyView()
            }
        )
    }
}
