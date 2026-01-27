//
//  FloatingButton.swift
//  DesignSystem
//
//  Created by 문종식 on 1/27/26.
//

import SwiftUI

public struct FloatingButton: View {
    @State var state: FloatingButtonState = .close
    
    public var body: some View {
        ZStack {
            if state == .open {
                Color(BNColor(.dim).uiColor)
                    .ignoresSafeArea()
                    .onTapGesture {
                        self.state = .close
                    }
            }
            HStack {
                Spacer()
                VStack(alignment: .trailing) {
                    Spacer()
                    FloatingCircleButton(
                        state: $state
                    )
                }
            }
            .padding(20)
        }
        
    }
}


#Preview {
    FloatingButton(state: .close)
}
