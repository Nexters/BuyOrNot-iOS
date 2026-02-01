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
    let itemQueue = BNQueue<BNSnackBarItem>()
    
    public var currentItem: BNSnackBarItem = .empty
    
    public var barState: BNSnackBarState = .inactive
    
    public func addItem(_ item: BNSnackBarItem) {
        switch barState {
        case .active:
            itemQueue.enqueue(item)
        case .inactive:
            currentItem = item
            show()
        }
    }
    
    public func show() {
        Task { [weak self] in
            await MainActor.run { [weak self] in
                self?.barState = .active
            }
            try? await Task.sleep(nanoseconds: 5 * .second)
            await MainActor.run { [weak self] in
                self?.barState = .inactive
            }
            try? await Task.sleep(nanoseconds: 300 * .millisecond)
            await MainActor.run { [weak self] in
                self?.currentItem = .empty
            }
            try? await Task.sleep(nanoseconds: 100 * .millisecond)
            if let item = self?.itemQueue.dequeue() {
                await MainActor.run { [weak self] in
                    self?.currentItem = item
                    self?.show()
                }
            }
        }
    }
}
