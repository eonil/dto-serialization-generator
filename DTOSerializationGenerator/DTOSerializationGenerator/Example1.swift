//
//  Example1.swift
//  SwiftDTOSerializationGenerator
//
//  Created by Hoon H. on 2016/05/19.
//  Copyright © 2016 Eonil. All rights reserved.
//

import Foundation

struct AAA {
    var bbb: Int
    var ccc: String
}

struct BBB {
    var a: AAA
    var a1: AAA?
}
