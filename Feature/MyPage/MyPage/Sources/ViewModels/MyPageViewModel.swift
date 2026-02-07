//
//  MyPageViewModel.swift
//  MyPage
//
//  Created by 문종식 on 1/18/26.
//

import SwiftUI

final class MyPageViewModel: ObservableObject {
    @Published var name: String = "이름입니다최대열자임"
    @Published var appVersion: String = "0.0.1"
    
    func didTapMenu(_ menu: MyPageMenu) {
        /// TODO: 작업 예정
    }
}
