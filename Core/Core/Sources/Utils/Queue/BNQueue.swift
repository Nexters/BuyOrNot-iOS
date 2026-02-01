//
//  Queue.swift
//  Core
//
//  Created by 문종식 on 2/1/26.
//

public final class BNQueue<T>: BNQueueable {
    private var inStack: [T] = []
    private var outStack: [T] = []
    
    public init(items: [T] = []) {
        self.inStack = items
    }
    
    public func enqueue(_ e: T) {
        inStack.append(e)
    }
    
    public func dequeue() -> T? {
        if outStack.isEmpty {
            outStack = inStack.reversed()
            inStack.removeAll()
        }
        
        return outStack.popLast()
    }
}
