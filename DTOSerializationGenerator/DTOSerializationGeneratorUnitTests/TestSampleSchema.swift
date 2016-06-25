//
//  TestSamples.swift
//  DTOSerializationGenerator
//
//  Created by Hoon H. on 2016/06/25.
//  Copyright © 2016 Eonil. All rights reserved.
//

// MARK: - Simple Structures

enum E1 {
    case c1
}
enum E2 {
    case c1(arg1: Int8, arg2: Float32, arg3: String)
}
struct S3 {
    var f1: Int16
    var f2: Float64
    var f3: String
}

// MARK: - Nested Structures

struct S4 {
    var f6: Array<E5>
    var f5: [E5?]
    var f4: E5?
}

enum E5 {
    case c1(arg1: Int8, arg2: Float32, arg3: String)
    case c2(arg1: E1, arg2: E2, arg3: S3)
    indirect case c3(arg1: S4, arg2: E5)
}



func main() {
//    print(E1.c1)
}