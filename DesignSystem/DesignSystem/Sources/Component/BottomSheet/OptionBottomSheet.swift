//
//  OptionBottomSheet.swift
//  DesignSystem
//
//  Created by 문종식 on 4/28/26.
//

import SwiftUI

public protocol OptionBottomSheetDisplayable {
    var title: String { get }
}

public struct OptionBottomSheetModifier<Item: OptionBottomSheetDisplayable>: ViewModifier {
    @Binding private var isPresented: Bool
    private let isEnableDismiss: Bool
    private let title: String
    private let selectedItem: Item?
    private let items: [Item]
    private let didSelectItem: (Item) -> Void

    public init(
        isPresented: Binding<Bool>,
        isEnableDismiss: Bool = true,
        title: String,
        selectedItem: Item?,
        items: [Item],
        didSelectItem: @escaping (Item) -> Void = { _ in }
    ) {
        self._isPresented = isPresented
        self.isEnableDismiss = isEnableDismiss
        self.title = title
        self.selectedItem = selectedItem
        self.items = items
        self.didSelectItem = didSelectItem
    }

    public func body(content: Content) -> some View {
        content
            .bnBottomSheet(
                isPresented: $isPresented,
                isEnableDismiss: isEnableDismiss,
                handleBottomSpacing: 16,
                child: { dismiss in
                    optionBottomSheetContent(dismiss: dismiss)
                }
            )
    }

    @ViewBuilder
    private func optionBottomSheetContent(dismiss: @escaping VoidCallBack) -> some View {
        VStack(alignment: .leading, spacing: 20) {
            BNText(title)
                .style(style: .s1sb, color: ColorPalette.gray950)

            ZStack {
                ScrollViewReader { proxy in
                    ScrollView {
                        LazyVStack(spacing: 18) {
                            ForEach(Array(items.enumerated()), id: \.offset) { index, item in
                                Button {
                                    dismiss()
                                    didSelectItem(item)
                                } label: {
                                    HStack {
                                        BNText(item.title)
                                            .style(
                                                style: isSelected(item) ? .s3sb : .b3m,
                                                color: isSelected(item) ? ColorPalette.gray950 : ColorPalette.gray700
                                            )
                                        Spacer()
                                        BNImage(.check)
                                            .style(color: ColorPalette.gray950, size: 20)
                                            .opacity(isSelected(item) ? 1 : 0)
                                            .padding(.vertical, 5)
                                    }
                                }
                                .id(index)
                            }
                            Spacer(minLength: 70)
                        }
                    }
                    .scrollIndicators(.hidden)
                    .defaultScrollAnchor(.top)
                    .onAppear {
                        scrollToSelectedItemIfNeeded(with: proxy)
                    }
                    .onChange(of: selectedItem?.title) { _, _ in
                        scrollToSelectedItemIfNeeded(with: proxy)
                    }
                }

                VStack {
                    Spacer()
                    LinearGradient(
                        gradient: Gradient(colors: [
                            ColorPalette.gray0.opacity(0),
                            ColorPalette.gray0
                        ]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .frame(height: 70)
                }
            }
            .frame(height: 238)
        }
        .padding(.horizontal, 24)
    }

    private func isSelected(_ item: Item) -> Bool {
        selectedItem?.title == item.title
    }

    private func scrollToSelectedItemIfNeeded(with proxy: ScrollViewProxy) {
        guard let selectedTitle = selectedItem?.title else { return }
        guard let selectedIndex = items.firstIndex(where: { $0.title == selectedTitle }) else { return }
        DispatchQueue.main.async {
            proxy.scrollTo(selectedIndex, anchor: .center)
        }
    }
}

public extension View {
    func optionBottomSheet<Item: OptionBottomSheetDisplayable>(
        isPresented: Binding<Bool>,
        isEnableDismiss: Bool = true,
        title: String,
        selectedItem: Item?,
        items: [Item],
        didSelectItem: @escaping (Item) -> Void = { _ in }
    ) -> some View {
        modifier(
            OptionBottomSheetModifier(
                isPresented: isPresented,
                isEnableDismiss: isEnableDismiss,
                title: title,
                selectedItem: selectedItem,
                items: items,
                didSelectItem: didSelectItem
            )
        )
    }
}
