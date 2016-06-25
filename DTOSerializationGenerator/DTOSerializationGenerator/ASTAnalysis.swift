//
//  ASTAnalysis.swift
//  DTOSerializationGenerator
//
//  Created by Hoon H. on 2016/06/25.
//  Copyright © 2016 Eonil. All rights reserved.
//

enum ASTAnalysisError: ErrorType {
    case notAnEntityDeclAtom(Atom)

    case notAnEnumDeclAtom(Atom)
    case missingEnumDeclInAtom(Atom)
    case missingEnumNameInAtom(Atom)

    case notAnEnumElementDeclAtom(Atom)
    case missingEnumElementDeclNameInAtom(Atom)

    case notAnStructDeclAtom(Atom)
    case missingStructDeclNameInAtom(Atom)

    case notAnVarDeclAtom(Atom)
    case missingVarDeclNameInAtom(Atom)
    case missingVarDeclTypeInAtom(Atom)

    case swiftDictionaryTypeIsNotSupported(String)
}

func analyzeAST(ast: Atom) throws -> Schema {
    return try analyzeSourceFileAST(ast)
}
private func isSourceFileAST(ast: Atom) -> Bool {
    return ast.list?.first?.value == "source_file"
}
private func analyzeSourceFileAST(ast: Atom) throws -> Schema {
    let children = ast.filterListAtoms()
    let entities = try children.filter(isEntityDeclAST).map(analyzeEntityDeclAST)
    return Schema(entities: entities)
}
private func isEntityDeclAST(ast: Atom) -> Bool {
    guard let decl = ast.getEntityDecl() else { return false }
    switch decl {
    case "enum_decl":   return true
    case "struct_decl": return true
    default:            return false
    }
}
private func analyzeEntityDeclAST(ast: Atom) throws -> Entity {
    guard isEntityDeclAST(ast) else { throw ASTAnalysisError.notAnEntityDeclAtom(ast) }
    guard let decl = ast.getEntityDecl() else { throw ASTAnalysisError.notAnEntityDeclAtom(ast) }
    switch decl {
    case "enum_decl":   return Entity.`enum`(try analyzeEnumDeclAST(ast))
    case "struct_decl": return Entity.`struct`(try analyzeStructDeclAST(ast))
    default:            throw ASTAnalysisError.notAnEntityDeclAtom(ast)
    }
}
private func isEnumDeclAST(ast: Atom) -> Bool {
    return ast.getEntityDecl() == "enum_decl"
}
private func analyzeEnumDeclAST(ast: Atom) throws -> EnumSchema {
    guard isEnumDeclAST(ast) else { throw ASTAnalysisError.missingEnumDeclInAtom(ast) }
    guard let name = ast.getEntityName() else { throw ASTAnalysisError.missingEnumNameInAtom(ast) }
    let cases = try ast.filterListAtoms().filter(isEnumElementDeclAST).map(analyzeEnumElementDeclAST)
    return EnumSchema(name: name, cases: cases)
}
private func isEnumElementDeclAST(ast: Atom) -> Bool {
    return ast.getEntityDecl() == "enum_element_decl"
}
private func analyzeEnumElementDeclAST(ast: Atom) throws -> EnumCaseSchema {
    guard isEnumElementDeclAST(ast) else { throw ASTAnalysisError.notAnEnumElementDeclAtom(ast) }
    guard let name = ast.getEntityName() else { throw ASTAnalysisError.missingEnumElementDeclNameInAtom(ast) }
    do {
        ast.filterListAtoms()
    }
    // TODO: Add parameters.
    return EnumCaseSchema(name: name, parameters: [])
}

private func isStructDeclAST(ast: Atom) -> Bool {
    return ast.getEntityDecl() == "struct_decl"
}
private func analyzeStructDeclAST(ast: Atom) throws -> StructSchema {
    guard isStructDeclAST(ast) else { throw ASTAnalysisError.notAnStructDeclAtom(ast) }
    guard let name = ast.getEntityName() else { throw ASTAnalysisError.missingStructDeclNameInAtom(ast) }
    let fields = try ast.filterListAtoms().filter(isVarDeclAST).map(analyzeVarDeclAST)
    return StructSchema(name: name, fields: fields)
}
private func isVarDeclAST(ast: Atom) -> Bool {
    return ast.getEntityDecl() == "var_decl"
}
private func analyzeVarDeclAST(ast: Atom) throws -> StructFieldSchema {
    guard isVarDeclAST(ast) else { throw ASTAnalysisError.notAnVarDeclAtom(ast) }
    guard let name = ast.getEntityName() else { throw ASTAnalysisError.missingVarDeclNameInAtom(ast) }
    guard let type = ast.getEntityType() else { throw ASTAnalysisError.missingVarDeclTypeInAtom(ast) }
    // TODO: Parse type expr.
    return StructFieldSchema(name: name, type: try parseTypeExpression(type))
}

import Foundation.NSCharacterSet
private func parseTypeExpression(s: String) throws -> TypeID {
    let s1 = s.stringByTrimmingCharactersInSet(NSCharacterSet(charactersInString: "\'"))
    let s2 = s1.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
    switch s2 {
    case "Int8":    return .atom(.int8)
    case "Int16":   return .atom(.int16)
    case "Int32":   return .atom(.int32)
    case "Int64":   return .atom(.int64)
    case "UInt8":   return .atom(.int8)
    case "UInt16":  return .atom(.int16)
    case "UInt32":  return .atom(.int32)
    case "UInt64":  return .atom(.int64)
    case "Float32": return .atom(.float32)
    case "Float64": return .atom(.float64)
    case "String":  return .atom(.string)
    default:        return try parseNonPrimitiveTypeExpression(s2)
    }
}
private enum E: ErrorType {
    case EOF
}
private func parseNonPrimitiveTypeExpression(s: String) throws -> TypeID {
    guard s.isEmpty == false else { throw E.EOF }
    guard s.characters.contains(":") == false else { throw ASTAnalysisError.swiftDictionaryTypeIsNotSupported(s) }

    if let c = tryStripping(s, start: "[", end: "]") {
        return TypeID.arrayOf(try parseTypeExpression(c))
    }
    if let c = tryStripping(s, start: "Array<", end: ">") {
        return TypeID.arrayOf(try parseTypeExpression(c))
    }
    if let c = tryStripping(s, start: "Optional<", end: ">") {
        return TypeID.optionalOf(try parseTypeExpression(c))
    }
    if let c = tryStripping(s, start: "", end: "?") {
        return TypeID.optionalOf(try parseTypeExpression(c))
    }
    return TypeID.entity(s)
}
//private func parseIdentifier(s: String) -> (identifier: String, rest: String) {
//    var buffer = ""
//    var rest = s
//    while s.isEmpty == false {
//        let (f, t) = rest.splitFirst()
//        if "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890_".characters.contains(f) {
//            buffer.append(f)
//            rest = t
//        }
//        else {
//            break
//        }
//    }
//    return (buffer, rest)
//}

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


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// MARK: -
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

private extension Atom {
    func getEntityDecl() -> String? {
        return list?.first?.value
    }
    func getEntityName() -> String? {
        guard let s = list?.second()?.value else { return nil }
        return tryStripping(s, start: "\"", end: "\"")
    }
    func getEntityType() -> String? {
        return list?.flatMap{$0.getAttributeValueForName("type")}.first
    }
    func getEntityAccess() -> String? {
        return list?.flatMap{$0.getAttributeValueForName("access")}.first
    }
//    func getEntityAttributes() -> [String] {
//
//    }
    func filterListAtoms() -> [Atom] {
        return list?.filter{ $0.list != nil } ?? []
    }
}
private extension Atom {
    func getAttributeValueForName(name: String) -> String? {
        guard let (n, v) = getNameValuePair() else { return nil }
        guard n == name else { return nil }
        return v
    }
    func getNameValuePair() -> (name: String, value: String)? {
        guard let s = value else { return nil }
        let parts = s.componentsSeparatedByString("=")
        guard parts.count >= 2 else { return nil }
        guard let (f, t) = parts.splitFirst() else { return nil }
        let t1 = t.joinWithSeparator("=")
        return (f, t1)
    }
}
/// - Returns: Non-nil if the string is enclosed by the start and end.
private func tryStripping(s: String, start: String, end: String) -> (String)? {
    let b1 = (start == "") || s.hasPrefix(start)
    let b2 = (end == "") || s.hasSuffix(end)
    guard b1 && b2 else { return nil }
    let d1 = start.characters.startIndex.distanceTo(start.characters.endIndex)
    let d2 = end.characters.startIndex.distanceTo(end.characters.endIndex)
    let i1 = s.characters.startIndex.advancedBy(+d1)
    let i2 = s.characters.endIndex.advancedBy(-d2)
    let s1 = s[i1..<i2]
    return s1
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// MARK: -
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

private extension Array {
    private func second() -> Element? {
        guard count >= 2 else { return nil }
        return self[1]
    }
    private func third() -> Element? {
        guard count >= 3 else { return nil }
        return self[2]
    }
    private func splitFirst() -> (Element, Array)? {
        if let first = first { return (first, Array(self[1..<count])) }
        fatalError()
    }
}
