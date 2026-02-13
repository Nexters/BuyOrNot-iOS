//
//  PolicyWebSheetView.swift
//  Auth
//
//  Created by Codex on 2/13/26.
//

import SwiftUI
import WebKit

struct PolicyWebSheetView: View {
    let url: URL
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            PolicyWebView(url: url)
                .ignoresSafeArea(edges: .bottom)
                .navigationTitle("약관")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("닫기") {
                            dismiss()
                        }
                    }
                }
        }
    }
}

private struct PolicyWebView: UIViewRepresentable {
    let url: URL

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.allowsBackForwardNavigationGestures = true
        return webView
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        if webView.url != url {
            webView.load(URLRequest(url: url))
        }
    }
}
