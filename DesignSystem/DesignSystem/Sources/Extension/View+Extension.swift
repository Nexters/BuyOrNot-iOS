//
//  View+Extension.swift
//  DesignSystem
//
//  Created by 문종식 on 2/6/26.
//

import SwiftUI

public extension View {
    func clearBackground() -> some View {
        self.background(ClearBackground())
    }
}
