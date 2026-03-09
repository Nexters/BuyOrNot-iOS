//
//  FeedDetailView.swift
//  Vote
//
//  Created by 이조은 on 2/25/26.
//

import SwiftUI
import DesignSystem

public struct FeedDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: FeedDetailViewModel
    let feedId: Int

    public init(viewModel: FeedDetailViewModel, feedId: Int) {
        self.viewModel = viewModel
        self.feedId = feedId
    }

    public var body: some View {
        VStack(spacing: 0) {
            BNNavigationBar(onLeadingTap: { dismiss() })

            switch viewModel.state {
            case .loading:
                Spacer()
                ProgressView()
                Spacer()

            case .error:
                Spacer()
                Text("피드를 불러올 수 없습니다")
                    .font(BNFont.font(.b3m))
                    .foregroundColor(BNColor(.type(.gray600)).color)
                Spacer()

            case .success:
                if let feed = viewModel.feed {
                        VoteFeed(
                            data: feed,
                            onDelete: {
                                Task {
                                    await viewModel.deleteFeed(feedId: feed.id)
                                    dismiss()
                                }
                            },
                            onVote: { optionId in
                                Task { await viewModel.vote(feedId: feed.id, optionId: optionId) }
                            }
                        )
                        .padding(.horizontal, 20)
                }
            }

            Spacer()
        }
        .navigationBarHidden(true)
        .task {
            await viewModel.fetchFeed(feedId: feedId)
        }
    }
}

