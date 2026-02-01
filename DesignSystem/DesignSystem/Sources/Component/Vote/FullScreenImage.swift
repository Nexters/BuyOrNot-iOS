//
//  FullScreenImage.swift
//  DesignSystem
//
//  Created by 이조은 on 2/2/26.
//

import SwiftUI

public struct FullScreenImageView: View {
    let imageURL: String

    @Environment(\.dismiss) private var dismiss

    @State private var scale: CGFloat = 1.0
    @State private var lastScale: CGFloat = 1.0
    @State private var offset: CGSize = .zero
    @State private var lastOffset: CGSize = .zero

    public init(imageURL: String) {
        self.imageURL = imageURL
    }

    public var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()

            AsyncImage(url: URL(string: imageURL)) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFit()
                        .scaleEffect(scale)
                        .offset(offset)
                        .gesture(
                            MagnificationGesture()
                                .onChanged { value in
                                    scale = lastScale * value
                                }
                                .onEnded { _ in
                                    lastScale = scale
                                    if scale < 1.0 {
                                        withAnimation {
                                            scale = 1.0
                                            lastScale = 1.0
                                        }
                                    }
                                }
                        )
                        .simultaneousGesture(
                            DragGesture()
                                .onChanged { value in
                                    if scale > 1.0 {
                                        offset = CGSize(
                                            width: lastOffset.width + value.translation.width,
                                            height: lastOffset.height + value.translation.height
                                        )
                                    }
                                }
                                .onEnded { _ in
                                    lastOffset = offset
                                }
                        )
                case .failure:
                    Image(systemName: "photo")
                        .foregroundColor(.gray)
                default:
                    ProgressView()
                        .tint(.white)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    BNImage(.close)
                        .image
                        .resizable()
                        .frame(width: 16, height: 16)
                        .foregroundStyle(BNColor(.gray0).color)
                }
            }
        }
    }
}
