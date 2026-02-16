//
//  SplashView.swift
//  Splash
//
//  Created by 이조은 on 2/14/26.
//

import SwiftUI
import DesignSystem

public struct SplashView: View {

    public init() { }

    public var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            BNLottie(
                asset: .splash,
                size: CGSize(width: 152, height: 152)
            ) { isComplete in
                
            }
            
            BNImage(.logo)
                .resizable()
                .scaledToFit()
                .frame(height: 40)
        }
        .padding(.bottom, 320)
    }
}

#Preview {
    SplashView()
}
