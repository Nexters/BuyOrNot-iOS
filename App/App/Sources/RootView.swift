//
//  RootView.swift
//  App
//
//  Created by 이조은 on 2/14/26.
//

import SwiftUI
//import Splash
import Vote
import Auth

struct RootView: View {
    @State private var router = Router()

    var body: some View {
        NavigationStack(path: $router.path) {
            HomeView(
                onNotificationTap: { router.navigate(to: .notification) },
                onProfileTap: { router.navigate(to: .myPage) },
                onCreateVoteTap: { router.showCreateVote = true }
            )
            .navigationDestination(for: AppDestination.self) { destination in
                switch destination {
                case .notification:
                    NotificationView()
                case .myPage:
                    MyPageView()
                }
            }
        }
        .sheet(isPresented: $router.showCreateVote) {
            CreateVoteView()
                .presentationDetents([.large])
                .presentationCornerRadius(18)
        }
        .environment(router)
    }
}
