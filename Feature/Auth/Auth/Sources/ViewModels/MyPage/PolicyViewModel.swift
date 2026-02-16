//
//  PolicyViewModel.swift
//  MyPage
//
//  Created by 문종식 on 2/7/26.
//

import SwiftUI
import Core

final class PolicyViewModel: ObservableObject {
    @Published var url: URL?
    
    func didTapMenu(_ menu: PolicyMenu) {
        let urlType: Constants.ConstantsKey = switch menu {
        case .privacy:
                .privacyPolicyURL
        case .service:
                .serviceTermsURL
        }
    }
    
    private func openWebView(
        type: Constants.ConstantsKey
    ) {
        let urlString = Constants.getValue(with: type)
        guard let url = URL(string: urlString) else {
            return
        }
        self.url = url
    }
}
