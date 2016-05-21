//
//  Parser2.swift
//  SwiftDTOSerializationGenerator
//
//  Created by Hoon H. on 2016/05/19.
//  Copyright © 2016 Eonil. All rights reserved.
//

private enum CharacterCategory {
    case Whitespace
    case OpeningBrace
    case ClosingBrace
    case Content
}
private extension Character {
    var category: CharacterCategory {
        get {
            switch self {
            case " ", "\t", "\n":   return .Whitespace
            case "(":               return .OpeningBrace
            case ")":               return .ClosingBrace
            default:                return .Content
            }
        }
    }
}
private extension String {
    func splitFirst() -> (first: Character, tail: String) {
        guard !isEmpty else { fatalError() }
        return (characters.first!, self[characters.startIndex.successor()..<characters.endIndex])
    }
}
private extension CollectionType {
    var entireRange: Range<Index> {
        get { return startIndex..<endIndex }
    }
}
private typealias Error2 = SymbolicExpressionParsingError







// Extra content will be abandoned. At least for now.
func parseSymbolicExpression(code: String) throws -> Atom {
    let (atom, rest) = try parse(code)
    guard rest.isEmpty == false else {
        return atom
    }
    return atom
}


private func parse(code: String) throws -> (Atom, String) {
    guard code.isEmpty == false else { throw Error2.EOF }
    let code1 = skipAllWhitespaces(code)
    if code1.hasPrefix("(") {
        return try parseList(code1)
    }
    else {
        return try parseValue(code1)
    }
}
private func parseList(code: String) throws -> (Atom, String) {
    let (first, tail) = code.splitFirst()
    guard first == "(" else { throw Error2.IllForm }
    let (atoms, rest) = try parseListAtoms(tail)
    return (Atom.List(atoms), rest)
}
private func parseListAtoms(code: String) throws -> ([Atom], String) {
    guard code.isEmpty == false else { return ([], "") }
    if code.splitFirst().first == ")" { return ([], code.splitFirst().tail) }
    let (atom, rest) = try parse(code)
    let rest1 = skipAllWhitespaces(rest)
    let (atoms1, rest2) = try parseListAtoms(rest1)
    return ([atom] + atoms1, rest2)
}
private func parseValue(code: String) throws -> (Atom, String) {
    var content = ""
    var s = code
    LOOP: while s.isEmpty == false {
        // `swiftc -dumpt-ast` produces s-expr with some special case string literals
        // which escapes whitespaces and even *braces*(!).
        // This handles such cases.
        do {
            if let (lit, rest) = try parseStringLiteral(s, opener: "\"", closer: "\"") {
                content.appendContentsOf(lit)
                s = rest
                continue
            }
            if let (lit, rest) = try parseStringLiteral(s, opener: "'", closer: "'") {
                content.appendContentsOf(lit)
                s = rest
                continue
            }
            if let (lit, rest) = try parseStringLiteral(s, opener: "(", closer: ")") {
                content.appendContentsOf(lit)
                s = rest
                continue
            }
        }
        let (first, tail) = s.splitFirst()
        switch first.category {
        case .Whitespace, .ClosingBrace:
            break LOOP
        default:
            content.append(first)
        }
        s = tail
    }
    return (Atom.Value(content), s)
}
private func parseStringLiteral(code: String, opener: Character, closer: Character) throws -> (String, String)? {
    enum Phase {
        case NotStarted
        case Running
        case Ended
    }
    var phase = Phase.NotStarted
    var content = ""
    var s = code
    LOOP: while s.isEmpty == false && phase != .Ended {
        let (first, tail) = s.splitFirst()
        content.append(first)
        switch phase {
        case .NotStarted:
            if first != opener { return nil }
            phase = .Running
        case .Running:
            if first == closer {
                phase = .Ended
            }
        case .Ended:
            fatalError()
        }
        s = tail
    }
    if phase != .Ended {
        throw Error2.IllForm
    }
    return (content, s)
}
private func skipAllWhitespaces(code: String) -> (String) {
    if code.isEmpty { return code }
    let (first, tail) = code.splitFirst()
    if first.category == .Whitespace { return skipAllWhitespaces(tail) }
    return code
}



































