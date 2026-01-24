//
//  ContentView.swift
//  App
//
//  Created by 문종식 on 1/20/26.
//


import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Buy Or Not")
        }
        .ignoresSafeArea()
    }
}

#Preview {
    ContentView()
}
