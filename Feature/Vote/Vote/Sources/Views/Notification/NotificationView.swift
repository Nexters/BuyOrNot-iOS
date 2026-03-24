//
//  NotificationView.swift
//  Vote
//
//  Created by 이조은 on 2/12/26.
//

import UIKit
import SwiftUI
import DesignSystem

public struct NotificationView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.openURL) private var openURL

    @ObservedObject var viewModel: NotificationViewModel
    @State private var isNotificationAuthorized: Bool = false

    public init(viewModel: NotificationViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        VStack(spacing: 0) {
            BNNavigationBar(title: "알림", onLeadingTap: { dismiss() })

            ScrollView {
                VStack(spacing: 0) {
                    NotificationFilterBar(selectedFilter: $viewModel.selectedFilter, onFilterChanged: { filter in
                        Task {
                            await viewModel.applyFilter(filter)
                        }
                    })
                        .padding(.top, 20)

                    if !isNotificationAuthorized {
                        NotificationPermissionBanner(onTap: {
                            if let url = URL(string: UIApplication.openSettingsURLString) {
                                openURL(url)
                            }
                        })
                            .padding(.top, 16)
                            .padding(.horizontal, 20)
                    }

                    switch viewModel.state {
                    case .loading:
                        ProgressView()
                            .padding(.top, 120)
                    case .empty:
                        AlarmEmptyView()
                            .padding(.top, 120)
                    case .error:
                        AlarmEmptyView()
                            .padding(.top, 120)
                    case .success:
                        NotificationListContent(
                            notifications: viewModel.notifications,
                            onTap: { feedId in
                                viewModel.didTapNotification(feedId: feedId)
                            }
                        )
                            .padding(.top, 10)
                    }
                }
            }
        }
        .background(ColorPalette.gray0)
        .navigationBarHidden(true)
        .task {
            viewModel.onAppear()
            await refreshNotificationPermission()
            await viewModel.fetchNotifications()
        }
        .onAppear {
            Task { await refreshNotificationPermission() }
        }
    }

    private func refreshNotificationPermission() async {
        let settings = await UNUserNotificationCenter.current().notificationSettings()
        let status = settings.authorizationStatus
        isNotificationAuthorized = status == .authorized || status == .provisional || status == .ephemeral
    }
}

enum NotificationFilter: String, CaseIterable {
    case all = "전체"
    case myVotes = "내가 올린 투표"
    case participated = "참여한 투표"
}

private struct NotificationFilterBar: View {
    @Binding var selectedFilter: NotificationFilter
    let onFilterChanged: (NotificationFilter) -> Void

    var body: some View {
        HStack(spacing: 8) {
            ForEach(NotificationFilter.allCases, id: \.self) { filter in
                BNChip(
                    title: filter.rawValue,
                    state: selectedFilter == filter ? .selected : .unselected,
                    onTap: {
                        selectedFilter = filter
                        onFilterChanged(filter)
                    }
                )
            }
            Spacer()
        }
        .padding(.horizontal, 20)
    }
}


private struct NotificationPermissionBanner: View {
    let onTap: () -> Void

    var body: some View {
        HStack(spacing: 8) {
            BNImage(.notification_fill)
                .resizable()
                .frame(width: 16, height: 16)
                .foregroundColor(ColorPalette.gray600)

            BNText("투표 종료 및 결과 소식을 받아보세요")
                .style(style: .b5m, color: ColorPalette.gray700)

            Spacer()

            Button {
                onTap()
            } label: {
                BNText("알림 켜기")
                    .style(style: .s5sb, color: ColorPalette.gray800)
            }
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 12)
        .background(ColorPalette.gray0)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(ColorPalette.gray200, lineWidth: 1)
        )
    }
}

private struct NotificationListContent: View {
    let notifications: [NotificationItemData]
    let onTap: (Int) -> Void

    var body: some View {
        LazyVStack(spacing: 0) {
            ForEach(notifications) { item in
                NotificationCell(item: item, onTap: { onTap(item.feedId) })
            }

            BNText("30일 전 알림까지 보여줘요")
                .style(style: .b5m, color: ColorPalette.gray600)
                .frame(maxWidth: .infinity)
                .padding(.top, 20)
        }
    }
}

private struct NotificationCell: View {
    let item: NotificationItemData
    let onTap: () -> Void
    @State private var isPressed = false

    var body: some View {
        Button {
            onTap()
        } label: {
            VStack {
                HStack(alignment: .center, spacing: 14) {
                    AsyncImage(url: URL(string: item.imageURL)) { image in
                        image
                            .resizable()
                            .scaledToFill()
                    } placeholder: {
                        ColorPalette.gray200
                    }
                    .frame(width: 48, height: 48)
                    .cornerRadius(10)

                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            BNText(item.status)
                                .style(style: .b5m, color: ColorPalette.gray600)

                            Spacer()

                            BNText(item.timeAgo)
                                .style(style: .b6m, color: ColorPalette.gray600)
                        }

                        BNText(item.message)
                            .style(style: .s3sb, color: ColorPalette.gray900)
                            .lineLimit(1)
                    }
                }

                Rectangle()
                    .fill(ColorPalette.gray100)
                    .frame(height: 2)
                    .padding(.top, 19)
            }
            .padding(.top, 19)
            .padding(.horizontal, 20)
        }
        .buttonStyle(PressableButtonStyle())
    }
}

private struct PressableButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(configuration.isPressed ? ColorPalette.gray50 : Color.clear)
    }
}
