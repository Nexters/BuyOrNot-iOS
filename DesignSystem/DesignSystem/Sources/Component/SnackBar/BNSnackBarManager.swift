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
    
    var currentItem: BNSnackBarItem = .empty
    
    var barState: BNSnackBarState = .inactive
    
    public func addItem(_ item: BNSnackBarItem) {
        switch barState {
        case .active:
            itemQueue.enqueue(item)
        case .inactive:
            show(item)
        }
    }
    
    public func show(_ item: BNSnackBarItem) {
        currentItem = item
        barState = .active
        Task { [weak self] in
            try? await Task.sleep(nanoseconds: 5 * .second)
            self?.barState = .inactive
            try? await Task.sleep(nanoseconds: 5 * .second / 2)
            self?.currentItem = .empty
            guard let item = self?.itemQueue.dequeue() else {
                return
            }
            self?.show(item)
        }
    }
}
