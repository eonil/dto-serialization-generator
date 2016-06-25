//
//  main.swift
//  ThreadSafeCOWArrayWrapper
//
//  Created by Hoon H. on 2016/06/03.
//  Copyright © 2016 Eonil. All rights reserved.
//

import Foundation

print("Hello, World!")

struct COWExample1<T> {
    private var box = Box<[T]>(value: [T]())
    var count: Int {
        return box.value.count
    }
    mutating func append(e: T) {
        ensureBoxUniqueRefed()
        box.value.append(e)
    }
    private mutating func ensureBoxUniqueRefed() {
        if isUniquelyReferencedNonObjC(&box) == false {
            box = box.duplicated()
        }
    }
}

private final class Box<T> {
    var value: T
    init(value: T) {
        self.value = value
    }
    func duplicated() -> Box<T> {
        return Box(value: value)
    }
}