//
//  FeedDetailView.swift
//  Vote
//
//  Created by 이조은 on 2/25/26.
//

import SwiftUI
import DesignSystem

public struct FeedDetailView: View {
    private struct ImageViewerDestination: Hashable, Identifiable {
        let imageURLs: [String]
        let initialIndex: Int
        var id: String { "\(imageURLs.joined(separator: "|"))-\(initialIndex)" }
    }

    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: FeedDetailViewModel
    let feedId: Int
    @State private var imageViewerDestination: ImageViewerDestination?

    public init(viewModel: FeedDetailViewModel, feedId: Int) {
        self.viewModel = viewModel
        self.feedId = feedId
    }

    public var body: some View {
        ZStack(alignment: .bottom) {
            VStack(spacing: 0) {
                BNNavigationBar(onLeadingTap: { dismiss() })

                switch viewModel.state {
                case .loading:
                    VStack {
                        Spacer()
                        ProgressView()
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)

                case .error:
                    VStack {
                        Spacer()
                        BNText("피드를 불러올 수 없습니다")
                            .style(style: .b3m, color: ColorPalette.gray600)
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)

                case .success:
                    if let feed = viewModel.feed {
                        VoteFeed(
                            data: feed,
                            showBottomDivider: false,
                            onDelete: {
                                Task {
                                    await viewModel.deleteFeed(feedId: feed.id)
                                    dismiss()
                                }
                            },
                            onReport: {
                                Task { await viewModel.reportFeed(feedId: feed.id) }
                            },
                            onBlock: {
                                Task {
                                    await viewModel.blockUser(userId: feed.userId, userName: feed.userName)
                                }
                            },
                            onVote: { optionId in
                                Task { await viewModel.vote(feedId: feed.id, optionId: optionId) }
                            },
                            onOpenImageViewer: { imageURLs, initialIndex in
                                imageViewerDestination = ImageViewerDestination(
                                    imageURLs: imageURLs,
                                    initialIndex: initialIndex
                                )
                            }
                        )
                        .frame(maxWidth: .infinity, alignment: .top)
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            VStack {
                Spacer()
                BNSnackBar(
                    item: viewModel.snackBar.currentItem,
                    state: $viewModel.snackBar.barState
                )
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .navigationBarHidden(true)
        .navigationDestination(item: $imageViewerDestination) { destination in
            FullScreenImageView(
                imageURLs: destination.imageURLs,
                initialIndex: destination.initialIndex
            )
        }
        .task {
            await viewModel.fetchFeed(feedId: feedId)
        }
    }
}
