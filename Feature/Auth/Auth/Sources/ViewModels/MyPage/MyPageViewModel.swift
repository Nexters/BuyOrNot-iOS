//
//  MyPageViewModel.swift
//  MyPage
//
//  Created by 문종식 on 1/18/26.
//

import SwiftUI
import Core

final class MyPageViewModel: ObservableObject {
    @Published var name: String = "이름입니다최대열자임"
    @Published var appVersion: String = "0.0.1"
    @Published var url: URL?
    
    func didTapMenu(_ menu: MyPageMenu) {
        switch menu {
        case .accountInfo:
            /// TODO: 작업 예정
        case .terms:
            /// TODO: 작업 예정
        case .feedback:
            openFeedbackUrl()
        }
    }
    
    private func openFeedbackUrl() {
        let urlString = Constants.getValue(with: .userFeedbackURL)
        guard let url = URL(string: urlString) else {
            return
        }
        self.url = url
    }
}
