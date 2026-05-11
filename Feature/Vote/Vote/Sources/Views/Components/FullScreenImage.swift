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
    @State private var showsChrome: Bool = true

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
                    ZoomableImageCell(
                        imageURL: url,
                        onSingleTap: {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                showsChrome.toggle()
                            }
                        },
                        onDismiss: { dismiss() }
                    )
                    .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .ignoresSafeArea()

            if showsChrome {
                Button {
                    dismiss()
                } label: {
                    BNImage(.close)
                        .style(color: ColorPalette.gray0, size: 24)
                }
                .padding(.leading, 20)
                .padding(.top, 16)
                .transition(.opacity)

                VStack {
                    Spacer()
                    BNText("\(currentIndex + 1) / \(imageURLs.count)")
                        .style(style: .b6m, color: ColorPalette.gray0)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(
                            Capsule()
                                .fill(Color.white.opacity(0.16))
                        )
                        .padding(.bottom, 24)
                }
                .frame(maxWidth: .infinity)
                .allowsHitTesting(false)
                .transition(.opacity)
            }
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
}

// MARK: - ZoomableImageCell

private struct ZoomableImageCell: View {
    let imageURL: String
    let onSingleTap: () -> Void
    let onDismiss: () -> Void

    var body: some View {
        ZoomableRemoteImageView(
            imageURL: imageURL,
            onSingleTap: onSingleTap,
            onDismiss: onDismiss
        )
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.black)
    }
}

// MARK: - ZoomableRemoteImageView

private struct ZoomableRemoteImageView: UIViewRepresentable {
    let imageURL: String
    let onSingleTap: () -> Void
    let onDismiss: () -> Void

    func makeCoordinator() -> Coordinator {
        Coordinator(onSingleTap: onSingleTap, onDismiss: onDismiss)
    }

    func makeUIView(context: Context) -> UIScrollView {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .black
        scrollView.delegate = context.coordinator
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 4.0
        scrollView.zoomScale = 1.0
        scrollView.bouncesZoom = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.decelerationRate = .fast
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.isScrollEnabled = false

        let imageView = context.coordinator.imageView
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .black
        imageView.isUserInteractionEnabled = true
        imageView.frame = scrollView.bounds

        scrollView.addSubview(imageView)
        context.coordinator.scrollView = scrollView

        let singleTap = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleSingleTap))
        singleTap.numberOfTapsRequired = 1

        let doubleTap = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleDoubleTap(_:)))
        doubleTap.numberOfTapsRequired = 2

        singleTap.require(toFail: doubleTap)
        imageView.addGestureRecognizer(singleTap)
        imageView.addGestureRecognizer(doubleTap)

        let dismissPan = UIPanGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleDismissPan(_:)))
        dismissPan.delegate = context.coordinator
        dismissPan.cancelsTouchesInView = false
        scrollView.addGestureRecognizer(dismissPan)
        context.coordinator.dismissPanGesture = dismissPan

        context.coordinator.loadImage(from: imageURL)

        return scrollView
    }

    func updateUIView(_ uiView: UIScrollView, context: Context) {
        if context.coordinator.currentURL != imageURL {
            context.coordinator.resetZoomState()
            context.coordinator.loadImage(from: imageURL)
        }
        context.coordinator.updateLayoutIfNeeded()
    }

    final class Coordinator: NSObject, UIScrollViewDelegate {
        let imageView = UIImageView()
        var scrollView: UIScrollView?
        weak var dismissPanGesture: UIPanGestureRecognizer?
        var currentURL: String?
        private var lastBoundsSize: CGSize = .zero
        private let onSingleTap: () -> Void
        private let onDismiss: () -> Void
        private var isDismissingByPan = false

        init(onSingleTap: @escaping () -> Void, onDismiss: @escaping () -> Void) {
            self.onSingleTap = onSingleTap
            self.onDismiss = onDismiss
        }

        func loadImage(from urlString: String) {
            currentURL = urlString
            imageView.image = nil

            guard let url = URL(string: urlString) else { return }
            KingfisherManager.shared.retrieveImage(
                with: url,
                options: [.callbackQueue(.mainAsync)]
            ) { [weak self] result in
                guard let self else { return }
                Task { @MainActor in
                    switch result {
                    case .success(let value):
                        self.imageView.image = value.image
                        self.resetZoomState()
                        self.updateImageFrame()
                        self.updateContentInsetForCentering()
                    case .failure:
                        self.imageView.image = UIImage(systemName: "photo")
                        self.imageView.tintColor = .gray
                        self.resetZoomState()
                        self.updateImageFrame()
                        self.updateContentInsetForCentering()
                    }
                }
            }
        }

        func resetZoomState() {
            guard let scrollView else { return }
            scrollView.setZoomScale(scrollView.minimumZoomScale, animated: false)
            scrollView.contentOffset = .zero
            scrollView.isScrollEnabled = false
            scrollView.contentInset = .zero
            imageView.transform = .identity
        }

        func updateImageFrame() {
            guard let scrollView else { return }
            let bounds = scrollView.bounds.size
            guard bounds.width > 0, bounds.height > 0 else { return }

            guard let image = imageView.image else {
                imageView.frame = CGRect(origin: .zero, size: bounds)
                scrollView.contentSize = bounds
                return
            }

            let imageSize = image.size
            guard imageSize.width > 0, imageSize.height > 0 else { return }

            let widthRatio = bounds.width / imageSize.width
            let heightRatio = bounds.height / imageSize.height
            let fitScale = min(widthRatio, heightRatio)

            let fittedSize = CGSize(
                width: imageSize.width * fitScale,
                height: imageSize.height * fitScale
            )

            imageView.frame = CGRect(origin: .zero, size: fittedSize)
            scrollView.contentSize = fittedSize
        }

        func updateLayoutIfNeeded() {
            guard let scrollView else { return }
            let bounds = scrollView.bounds.size
            guard bounds.width > 0, bounds.height > 0 else { return }
            guard bounds != lastBoundsSize else { return }
            lastBoundsSize = bounds

            let previousZoom = scrollView.zoomScale
            updateImageFrame()
            scrollView.setZoomScale(max(scrollView.minimumZoomScale, previousZoom), animated: false)
            updateContentInsetForCentering()
        }

        func updateContentInsetForCentering() {
            guard let scrollView else { return }
            let bounds = scrollView.bounds.size
            let contentSize = scrollView.contentSize

            let horizontalInset = max((bounds.width - contentSize.width) / 2, 0)
            let verticalInset = max((bounds.height - contentSize.height) / 2, 0)
            scrollView.contentInset = UIEdgeInsets(
                top: verticalInset,
                left: horizontalInset,
                bottom: verticalInset,
                right: horizontalInset
            )
        }

        @objc func handleSingleTap() {
            onSingleTap()
        }

        @objc func handleDoubleTap(_ recognizer: UITapGestureRecognizer) {
            guard let scrollView else { return }

            if scrollView.zoomScale > scrollView.minimumZoomScale {
                scrollView.setZoomScale(scrollView.minimumZoomScale, animated: true)
                return
            }

            let point = recognizer.location(in: imageView)
            let targetScale = min(scrollView.maximumZoomScale, 2.5)
            let zoomRect = zoomRect(for: targetScale, center: point, in: scrollView)
            scrollView.zoom(to: zoomRect, animated: true)
        }

        @objc func handleDismissPan(_ recognizer: UIPanGestureRecognizer) {
            guard let scrollView else { return }
            guard scrollView.zoomScale <= scrollView.minimumZoomScale + 0.01 else { return }

            let translation = recognizer.translation(in: scrollView)
            let velocity = recognizer.velocity(in: scrollView)

            switch recognizer.state {
            case .began:
                isDismissingByPan = false
            case .changed:
                guard abs(translation.y) > abs(translation.x) else { return }
                isDismissingByPan = true
                let progress = min(abs(translation.y) / 420.0, 1.0)
                let scale = 1.0 - (progress * 0.08)
                imageView.transform = CGAffineTransform(translationX: 0, y: translation.y)
                    .scaledBy(x: scale, y: scale)
            case .ended, .cancelled, .failed:
                guard isDismissingByPan else { return }
                let shouldDismiss = abs(translation.y) > 140 || abs(velocity.y) > 1200
                if shouldDismiss {
                    onDismiss()
                } else {
                    UIView.animate(withDuration: 0.22, delay: 0, options: [.curveEaseOut]) {
                        self.imageView.transform = .identity
                    }
                }
                isDismissingByPan = false
            default:
                break
            }
        }

        func viewForZooming(in scrollView: UIScrollView) -> UIView? {
            imageView
        }

        func scrollViewDidZoom(_ scrollView: UIScrollView) {
            updateContentInsetForCentering()
            scrollView.isScrollEnabled = scrollView.zoomScale > scrollView.minimumZoomScale + 0.01
        }

        func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
            if scale <= scrollView.minimumZoomScale {
                scrollView.setZoomScale(scrollView.minimumZoomScale, animated: true)
                scrollView.isScrollEnabled = false
            }
        }

        private func zoomRect(for scale: CGFloat, center: CGPoint, in scrollView: UIScrollView) -> CGRect {
            let size = CGSize(
                width: scrollView.bounds.size.width / scale,
                height: scrollView.bounds.size.height / scale
            )
            return CGRect(
                x: center.x - (size.width / 2),
                y: center.y - (size.height / 2),
                width: size.width,
                height: size.height
            )
        }
    }
}

extension ZoomableRemoteImageView.Coordinator: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        true
    }
}
