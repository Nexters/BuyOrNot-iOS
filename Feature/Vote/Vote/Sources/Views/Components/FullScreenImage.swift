//
//  FullScreenImage.swift
//  Vote
//
//  Created by 이조은 on 2/2/26.
//

import SwiftUI
import UIKit
import DesignSystem

public struct FullScreenImageView: View {
    let imageURL: String

    @State private var scale: CGFloat = 1.0
    @State private var lastScale: CGFloat = 1.0
    @State private var offset: CGSize = .zero
    @State private var lastOffset: CGSize = .zero

    public init(imageURL: String) {
        self.imageURL = imageURL
    }

    public var body: some View {
        ZStack(alignment: .topLeading) {
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
                                            offset = .zero
                                            lastOffset = .zero
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
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            Button {
                dismissFullScreen()
            } label: {
                BNImage(.close)
                    .style(color: ColorPalette.gray0, size: 16)
            }
            .padding(.leading, 20)
            .padding(.top, 16)
        }
    }
}

// MARK: - UIKit Presentation

func presentFullScreenImage(imageURL: String) {
    let hostingController = UIHostingController(
        rootView: FullScreenImageView(imageURL: imageURL)
    )
    hostingController.modalPresentationStyle = .overFullScreen

    guard let window = keyWindow,
          let topVC = topViewController else { return }

    let transition = CATransition()
    transition.duration = 0.3
    transition.type = .push
    transition.subtype = .fromRight
    transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
    window.layer.add(transition, forKey: kCATransition)

    topVC.present(hostingController, animated: false)
}

private func dismissFullScreen() {
    guard let window = keyWindow,
          let topVC = topViewController else { return }

    let transition = CATransition()
    transition.duration = 0.3
    transition.type = .push
    transition.subtype = .fromLeft
    transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
    window.layer.add(transition, forKey: kCATransition)

    topVC.dismiss(animated: false)
}

private var keyWindow: UIWindow? {
    UIApplication.shared.connectedScenes
        .compactMap { $0 as? UIWindowScene }
        .first?.windows.first
}

private var topViewController: UIViewController? {
    guard var topVC = keyWindow?.rootViewController else { return nil }
    while let presented = topVC.presentedViewController {
        topVC = presented
    }
    return topVC
}
