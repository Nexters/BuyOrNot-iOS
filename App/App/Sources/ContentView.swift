//
//  ContentView.swift
//  App
//
//  Created by 문종식 on 1/20/26.
//


import SwiftUI
import Auth

struct ContentView: View {
    @StateObject var container = DIContainer()
    var body: some View {
        AppView()
            .environmentObject(
                container
            )
    }
}

#Preview {
    ContentView()
}
