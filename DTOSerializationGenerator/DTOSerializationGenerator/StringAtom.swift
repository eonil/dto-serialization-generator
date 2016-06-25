//
//  StringAtom.swift
//  DTOSerializationGenerator
//
//  Created by Hoon H. on 2016/06/24.
//  Copyright © 2016 Eonil. All rights reserved.
//

protocol StringAtom {
    func stringify() -> String
}
extension String: StringAtom {
    func stringify() -> String {
        return self
    }
}
struct StringList: StringAtom, ArrayLiteralConvertible {
    typealias Element = StringAtom
    let tokens: [StringAtom]
    init() {
        tokens = []
    }
    init(arrayLiteral elements: Element...) {
        self.tokens = elements
    }
    init<S: SequenceType where S.Generator.Element == Element>(_ elements: S) {
        self.tokens = Array(elements)
    }
    func stringify() -> String {
        return tokens.map({ $0.stringify() }).joinWithSeparator(" ")
    }

}

extension SequenceType where Generator.Element: StringAtom {
    func toStringList() -> StringList {
        return StringList(Array(map{ $0 as StringAtom }))
    }
}