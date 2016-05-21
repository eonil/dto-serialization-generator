//
//  main.swift
//  SwiftDTOSerializationGenerator
//
//  Created by Hoon H. on 2016/05/19.
//  Copyright © 2016 Eonil. All rights reserved.
//

import Foundation


//let x = AAA(bbb: 1, ccc: "XX")
//let m = Mirror(reflecting: x)
//print(m)
//
//for m1 in m.children {
//    print(m1)
//}

let p = "/Users/Eonil/Workshop/Development/dto-serialization-generator.swift/DTOSerializationGenerator/DTOSerializationGenerator/Example1.swift"
let s = runCommand("/usr/bin/swiftc", args: "-dump-ast", p)
let s1 = s.error.joinWithSeparator("\n")
let tree = try! parseSymbolicExpression(s1)
print(tree)
let f = readSourceFile(tree)
print(f)













