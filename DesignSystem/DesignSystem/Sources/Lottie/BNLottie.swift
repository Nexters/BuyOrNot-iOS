//
//  BNLottie.swift
//  DesignSystem
//
//  Created by 문종식 on 2/16/26.
//

import Lottie
import SwiftUI

public struct BNLottie: View {
    let asset: BNLottieAsset
    let size: CGSize
    let animationCompletionHandler: ((Bool) -> Void)?
    
    public init(
        asset: BNLottieAsset,
        size: CGSize,
        animationCompletionHandler: ((Bool) -> Void)?
    ) {
        self.asset = asset
        self.size = size
        self.animationCompletionHandler = animationCompletionHandler
    }
    
    public var body: some View {
        LottieView {
            LottieAnimation.named(
                asset.rawValue,
                bundle: .designSystem,
            )
        } placeholder: {
            LoadingIndicator()
        }
        .playing(loopMode: .loop)
        .animationDidFinish{ completed in
            if let animationCompletionHandler {
                animationCompletionHandler(completed)
            }
        }
        .frame(
            width: size.width,
            height: size.height
        )
    }
}

struct LoadingIndicator: View {
  var body: some View {
    Image(systemName: "rays")
      .rotationEffect(animating ? Angle.degrees(360) : .zero)
      .animation(
        Animation
          .linear(duration: 2)
          .repeatForever(autoreverses: false),
        value: animating
      )
      .onAppear {
        animating = true
      }
  }

  @State private var animating = false

}
