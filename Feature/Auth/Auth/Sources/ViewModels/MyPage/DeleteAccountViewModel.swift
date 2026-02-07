//
//  DeleteAccountViewModel.swift
//  MyPage
//
//  Created by 문종식 on 2/7/26.
//

import SwiftUI

final class DeleteAccountViewModel: ObservableObject {
    @Published var name: String = "닉네임"
    @Published var guide: String = "앗 여기는 '떠날까말까'예요!\n혹시 잘못들어오셨나요?"
    @Published var showDeleteAccountAlert: Bool = false
    
    func didTapDeleteAccountButton() {
        showDeleteAccountAlert.toggle()
    }
}
