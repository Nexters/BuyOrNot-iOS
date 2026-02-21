//
//  SplashView.swift
//  Splash
//
//  Created by 이조은 on 2/14/26.
//

import SwiftUI
import DesignSystem

public struct SplashView: View {
    private let delegate: SplashDelegate?
    
    public init(_ delegate: SplashDelegate? = nil) {
        self.delegate = delegate
    }

    public var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            BNLottie(
                asset: .splash,
                size: CGSize(width: 152, height: 152)
            ) { isComplete in
                if isComplete, let delegate {
                    delegate.completeSplash()
                }
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
