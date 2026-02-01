//
//  BNQueueable.swift
//  Core
//
//  Created by 문종식 on 2/1/26.
//

public protocol BNQueueable<Element> {
    associatedtype Element
    mutating func enqueue(_ e: Element)
    mutating func dequeue() -> Element?
}
