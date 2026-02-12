//
//  AlramView.swift
//  Vote
//
//  Created by 이조은 on 2/12/26.
//

import SwiftUI
import DesignSystem

// TODO: 임시 데이터, 추후 삭제 예정
struct NotificationItem: Identifiable {
    let id: String
    let imageURL: String
    let status: String
    let message: String
    let timeAgo: String
    let isRead: Bool

    static let samples: [NotificationItem] = [
        .init(id: "1", imageURL: "https://example.com/1.jpg", status: "투표 종료", message: "78% '애매하긴 해!'", timeAgo: "6시간 전", isRead: false),
        .init(id: "2", imageURL: "https://example.com/2.jpg", status: "투표 종료", message: "56% '사! 가즈아!'", timeAgo: "3일 전", isRead: true),
        .init(id: "3", imageURL: "https://example.com/3.jpg", status: "투표 종료", message: "90% '애매하긴 해!'", timeAgo: "6일 전", isRead: false),
        .init(id: "4", imageURL: "https://example.com/4.jpg", status: "투표 종료", message: "무승부! 2차전 가보자고!", timeAgo: "1주 전", isRead: true)
    ]
}

public struct NotificationView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedFilter: NotificationFilter = .myVotes
    @State private var notifications: [NotificationItem] = NotificationItem.samples

    public init() {}

    public var body: some View {
        VStack(spacing: 0) {
            NotificationNavigationBar(onBackTap: { dismiss() })

            NotificationFilterBar(selectedFilter: $selectedFilter)
                .padding(.top, 20)

            NotificationPermissionBanner(onTap: { })
                .padding(.top, 16)
                .padding(.horizontal, 20)

            if notifications.isEmpty {
                AlarmEmptyView()
                    .padding(.top, 120)
            } else {
                NotificationListView(notifications: notifications)
                    .padding(.top, 10)
            }

            Spacer()
        }
        .background(BNColor(.type(.gray0)).color)
        .navigationBarHidden(true)
    }
}

enum NotificationFilter: String, CaseIterable {
    case all = "전체"
    case myVotes = "내가 올린 투표"
    case participated = "참여한 투표"
}

private struct NotificationNavigationBar: View {
    let onBackTap: () -> Void

    var body: some View {
        HStack(spacing: 0) {
            Button(action: onBackTap) {
                BNImage(.left)
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundColor(BNColor(.type(.gray900)).color)
                    .padding(10)
            }

            Text("알림")
                .font(BNFont.font(.t1b))
                .foregroundColor(BNColor(.type(.gray900)).color)

            Spacer()
        }
        .padding(.horizontal, 10)
        .frame(height: 60)
    }
}

private struct NotificationFilterBar: View {
    @Binding var selectedFilter: NotificationFilter

    var body: some View {
        HStack(spacing: 8) {
            ForEach(NotificationFilter.allCases, id: \.self) { filter in
                BNChip(
                    title: filter.rawValue,
                    state: selectedFilter == filter ? .selected : .unselected,
                    onTap: { selectedFilter = filter }
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
        Button {
            onTap()
        } label: {
            HStack(spacing: 8) {
                BNImage(.notification_fill)
                    .resizable()
                    .frame(width: 16, height: 16)
                    .foregroundColor(BNColor(.type(.gray600)).color)

                Text("투표 종료 및 결과 소식을 받아보세요")
                    .font(BNFont.font(.b5m))
                    .foregroundColor(BNColor(.type(.gray700)).color)

                Spacer()

                Button {
                    // TODO: 알림 허용 로직
                } label: {
                    Text("알림 켜기")
                        .font(BNFont.font(.s5sb))
                        .foregroundColor(BNColor(.type(.gray800)).color)
                }
            }
            .padding(.horizontal, 18)
            .padding(.vertical, 12)
            .background(BNColor(.type(.gray0)).color)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(BNColor(.type(.gray200)).color, lineWidth: 1)
            )
        }
    }
}

private struct NotificationListView: View {
    let notifications: [NotificationItem]

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(notifications.indices, id: \.self) { index in
                    let item = notifications[index]

                    NotificationCell(item: item)
                }

                Text("30일 전 알림까지 보여줘요")
                    .font(BNFont.font(.b5m))
                    .foregroundColor(BNColor(.type(.gray600)).color)
                    .frame(maxWidth: .infinity)
                    .padding(.top, 20)
            }
        }
    }
}

private struct NotificationCell: View {
    let item: NotificationItem
    @State private var isPressed = false

    var body: some View {
        Button {
            print("Notification tapped: \(item.id)")
        } label: {
            VStack {
                HStack(alignment: .center, spacing: 14) {
                    AsyncImage(url: URL(string: item.imageURL)) { image in
                        image
                            .resizable()
                            .scaledToFill()
                    } placeholder: {
                        BNColor(.type(.gray200)).color
                    }
                    .frame(width: 48, height: 48)
                    .cornerRadius(10)

                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Text(item.status)
                                .font(BNFont.font(.b5m))
                                .foregroundColor(BNColor(.type(.gray600)).color)

                            Spacer()

                            Text(item.timeAgo)
                                .font(BNFont.font(.b6m))
                                .foregroundColor(BNColor(.type(.gray600)).color)
                        }

                        Text(item.message)
                            .font(BNFont.font(.s3sb))
                            .foregroundColor(BNColor(.type(.gray900)).color)
                            .lineLimit(1)
                    }
                }

                Rectangle()
                    .fill(BNColor(.type(.gray100)).color)
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
            .background(configuration.isPressed ? BNColor(.type(.gray50)).color : Color.clear)
    }
}

#Preview {
    let _ = BNFont.loadFonts()
    NotificationView()
}
