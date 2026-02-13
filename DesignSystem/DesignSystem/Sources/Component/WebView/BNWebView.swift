//
//  WebView.swift
//  DesignSystem
//
//  Created by 문종식 on 2/13/26.
//

import SwiftUI
import WebKit

public struct BNWebView: UIViewRepresentable {
    private let url: URL?
    
    public init(urlString: String) {
        self.url = URL(string: urlString)
    }
    
    public init(url: URL) {
        self.url = url
    }

    public func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }

    public func updateUIView(_ uiView: WKWebView, context: Context) {
        guard let url else { return }
        let request = URLRequest(url: url)
        uiView.load(request)
    }
}
