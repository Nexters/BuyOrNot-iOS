//
//  AppView.swift
//  App
//
//  Created by 문종식 on 1/20/26.
//

import SwiftUI
import Splash
import Auth
import Vote

struct AppView: View {
    @State private var launchState: LaunchState = .main
    
    var body: some View {
        switch launchState {
        case .splash:
            SplashView()
        case .login:
            LoginView()
        case .main:
            RootView()
        }
    }
}

final class NavigationCoordinator: ObservableObject {
    @Published var navigationPath = NavigationPath()
}

struct RootView: View {
    @StateObject var navigationCoordinator = NavigationCoordinator()
    
    var body: some View {
        NavigationStack(
            path: $navigationCoordinator.navigationPath
        ) {
            HomeView()
                .navigationDestination(for: String.self) { destination in
                    switch destination {
                    case "MyPage":
                        MyPageView()
                    case "Notification":
                        NotificationView()
                    default:
                        EmptyView()
                    }
                }
        }
        .environmentObject(navigationCoordinator)
    }
}

struct HomeView: View {
    @EnvironmentObject var navigationCoordinator: NavigationCoordinator
    @State private var isPresented: Bool = false
    var body: some View {
        // NavigationBar
        // FeedSegmentedControl
        VStack(spacing: 10) {
            Button {
                isPresented.toggle()
            } label: {
                Text("CreateVote")
            }
            
            Button {
                navigationCoordinator.navigationPath.append("Notification")
            } label: {
                Text("Notification")
            }
            
            Button {
                navigationCoordinator.navigationPath.append("MyPage")
            } label: {
                Text("MyPage")
            }
        }
        .sheet(isPresented: $isPresented) {
            CreateVoteView()
                .presentationDetents([.large])
                .presentationCornerRadius(18)
        }
    }
}


#Preview {
    AppView()
}
