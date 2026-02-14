//
//  BNSnackBarManager.swift
//  DesignSystem
//
//  Created by 문종식 on 2/1/26.
//

import Core
import SwiftUI

@Observable
public final class BNSnackBarManager {
    public init() {
        
    }
    
    let itemQueue = BNQueue<BNSnackBarItem>()
    
    public var currentItem: BNSnackBarItem = .empty
    
    public var barState: BNSnackBarState = .inactive
    
    public func addItem(_ item: BNSnackBarItem) {
        Task { @MainActor [weak self] in
            guard let self else { return }
            switch barState {
            case .active:
                itemQueue.enqueue(item)
            case .inactive:
                currentItem = item
                show()
            }
        }
    }

    public func show() {
        barState = .active
        Task { @MainActor [weak self] in
            guard let self else { return }
            try? await Task.sleep(nanoseconds: 5 * .second)
            barState = .inactive
            try? await Task.sleep(nanoseconds: 300 * .millisecond)
            currentItem = .empty
            try? await Task.sleep(nanoseconds: 100 * .millisecond)
            if let item = itemQueue.dequeue() {
                currentItem = item
                show()
            }
        }
    }
}
