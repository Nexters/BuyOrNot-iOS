//
//  FullScreenImage.swift
//  Vote
//
//  Created by 이조은 on 2/2/26.
//

import SwiftUI
import UIKit
import DesignSystem
import Kingfisher

// MARK: - FullScreenImageView

public struct FullScreenImageView: View {
    let imageURLs: [String]
    let initialIndex: Int

    @Environment(\.dismiss) private var dismiss
    @State private var currentIndex: Int

    public init(imageURLs: [String], initialIndex: Int = 0) {
        self.imageURLs = imageURLs
        self.initialIndex = initialIndex
        _currentIndex = State(initialValue: initialIndex)
    }

    public var body: some View {
        ZStack(alignment: .topLeading) {
            Color.black.ignoresSafeArea()

            TabView(selection: $currentIndex) {
                ForEach(Array(imageURLs.enumerated()), id: \.offset) { index, url in
                    ZoomableImageCell(imageURL: url)
                        .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .ignoresSafeArea()

            Button {
                dismiss()
            } label: {
                BNImage(.close)
                    .style(color: ColorPalette.gray0, size: 16)
            }
            .padding(.leading, 20)
            .padding(.top, 16)
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
}

// MARK: - ZoomableImageCell

private struct ZoomableImageCell: View {
    let imageURL: String

    @State private var scale: CGFloat = 1.0
    @State private var lastScale: CGFloat = 1.0
    @State private var offset: CGSize = .zero
    @State private var lastOffset: CGSize = .zero

    var body: some View {
        KFImage.url(URL(string: imageURL))
            .placeholder {
                ProgressView()
                    .tint(.white)
            }
            .onFailureView {
                Image(systemName: "photo")
                    .foregroundColor(.gray)
            }
            .resizable()
            .scaledToFit()
            .scaleEffect(scale)
            .offset(offset)
            .gesture(
                MagnificationGesture()
                    .onChanged { value in
                        scale = max(1.0, lastScale * value)
                    }
                    .onEnded { _ in
                        lastScale = scale
                        if scale < 1.0 {
                            withAnimation {
                                scale = 1.0
                                lastScale = 1.0
                                offset = .zero
                                lastOffset = .zero
                            }
                        }
                    }
            )
            .simultaneousGesture(
                DragGesture()
                    .onChanged { value in
                        guard scale > 1.0 else { return }
                        offset = CGSize(
                            width: lastOffset.width + value.translation.width,
                            height: lastOffset.height + value.translation.height
                        )
                    }
                    .onEnded { _ in
                        guard scale > 1.0 else { return }
                        lastOffset = offset
                    }
            )
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.black)
    }
}
