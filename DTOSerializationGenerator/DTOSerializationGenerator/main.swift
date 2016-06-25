//
//  main.swift
//  SwiftDTOSerializationGenerator
//
//  Created by Hoon H. on 2016/05/19.
//  Copyright © 2016 Eonil. All rights reserved.
//

import Foundation

enum Error: ErrorType {
    case missingSourceFileFromTree(Atom)
}
let p = "/Users/Eonil/Workshop/Development/dto-serialization-generator.swift/DTOSerializationGenerator/DTOSerializationGeneratorUnitTests/TestSampleSchema.swift"
let s = runCommand("/usr/bin/swiftc", args: "-dump-ast", p)
let s1 = s.error.joinWithSeparator("\n")
let tree = try! parseSymbolicExpression(s1)
print(tree)
let k = try! analyzeAST(tree)
print(k)
let c = generateFunctionToEncodeSchema(k)
print(c.stringify())














