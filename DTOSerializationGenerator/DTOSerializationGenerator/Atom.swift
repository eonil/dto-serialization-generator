//
//  Atom.swift
//  SwiftDTOSerializationGenerator
//
//  Created by Hoon H. on 2016/05/20.
//  Copyright © 2016 Eonil. All rights reserved.
//

enum Atom {
    case List([Atom])
    case Value(String)
}
extension Atom {
    var value: String? {
        get {
            switch self {
            case .Value(let content):   return content
            default:                    return nil
            }
        }
    }
    var list: [Atom]? {
        get {
            switch self {
            case .List(let atoms):      return atoms
            default:                    return nil
            }
        }
    }
}
extension Atom: CustomStringConvertible {
    var description: String {
        get {
            switch self {
            case .List(let subatoms):
                let a = Array(subatoms.map({ $0.description.componentsSeparatedByString("\n").map { "- " + $0 }.joinWithSeparator("\n") }))
                let s = a.joinWithSeparator("\n")
                return s
            case .Value(let content):
                return content
            }
        }
    }
}
