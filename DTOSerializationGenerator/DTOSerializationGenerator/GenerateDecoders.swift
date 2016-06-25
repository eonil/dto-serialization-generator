//
//  SerializationGenerator.swift
//  DTOSerializationGenerator
//
//  Created by Hoon H. on 2016/06/23.
//  Copyright © 2016 Eonil. All rights reserved.
//

func generateFunctionToDecodeJSONArrayToTuple(k: TupleSchema) -> StringList {
//    func decodeJSON(j: JSONArray) throws -> (f1: F1, f2, f3) {
//        guard j.count >= 2 else { throw DTOError.insufficientArrayElement(j) }
//        return (
//            try decodeJSON(j[0]) as F1,
//            try decodeJSON(j[1]) as F2,
//            try decodeJSON(j[2]) as F3,
//        )
//    }
    func decodeJSONToToken(index: Int) -> StringList {
        return ["try decodeJSON(j[\(index)]) as \(typeIDToStringList(k.elements[index].type).stringify()),"]
    }
    let elementGetTokens = (0..<k.elements.count).map(decodeJSONToToken).toStringList()
    return [
        "func decodeJSON(j: JSONArray) throws", "->", tupleSchemaToTokens(k), "{",
            "    guard j.count >= 2 else { throw DTOError.insufficientArrayElement(j) }",
            "    return", "(",
                elementGetTokens,
            "    )",
        "}",
    ]
}
func generateFunctionToDecodeJSONStringToEnum(k: EnumSchema) -> StringList {
//    func decodeJSON(j: JSONString) throws -> Foo {
//        switch j {
//        case "bar": return Foo.bar
//        case "baz": return Foo.baz
//        default:    throw DTOError.unknownEnumCode(j)
//        }
//    }
    assert(k.isParametric == false)
    func caseToTokens(c: EnumCaseSchema) -> StringList {
        return ["case \"\(c.name)\":", "return .\(c.name)"]
    }
    return [
        "func decodeJSON(j: JSONString) throws", "->", k.name, "{",
            "switch", "j", "{",
                k.cases.map(caseToTokens).toStringList(),
            "default: throw DTOError.unknownEnumCode(j)",
            "}",
        "}",
    ]
}
func generateFunctionToDecodeJSONArrayToParametricEnum(k: EnumSchema) -> StringList {
//    func decodeJSON(j: JSONArray) throws -> Foo {
//        guard j.count >= 1 else { throw DTOError.insufficientArrayElement(j) }
//        switch j[0] {
//        case "bar":
//            guard j.count >= (1 + 2) else { throw DTOError.insufficientArrayElement(j) }
//            return Foo.bar(
//                f1: try decodeJSON(j[1]) as F1,
//                try decodeJSON(j[2]) as F2,
//            )
//
//        case "baz":
//            guard j.count >= (1 + 2) else { throw DTOError.insufficientArrayElement(j) }
//            return Foo.baz(
//                try decodeJSON(j[1]) as F1,
//                f2: try decodeJSON(j[2]) as F2,
//            )
//        }
//    }
    assert(k.isParametric == true)
    func caseParamToTokens(index: Int, p: EnumParameter) -> StringList {
        if let n = p.name { return ["\(n): decodeJSON(j[\(index + 1)]) as \(typeIDToStringList(p.type).stringify()),"] }
        return ["decodeJSON(j[\(index + 1)]) as \(typeIDToStringList(p.type).stringify()),"]
    }
    func caseToTokens(c: EnumCaseSchema) -> StringList {
        return [
            "case \"\(c.name)\":",
                "guard j.count >= (1 + \(c.parameters.count)) else { throw DTOError.insufficientArrayElement(j) }",
                "return .\(c.name)(",
                    c.parameters.enumerate().map(caseParamToTokens).toStringList(),
                ")"
        ]
    }
    return [
        "func decodeJSON(j: JSONString) throws", "->", k.name, "{",
            "guard j.count >= 1 else { throw DTOError.insufficientArrayElement(j) }",
            "switch", "j", "{",
                k.cases.map(caseToTokens).toStringList(),
            "}",
        "}",
    ]
}
func generateFunctionToDecodeJSONDictionaryToStruct(k: StructSchema) -> StringList {
//    func decodeJSON(j: JSONDictionary) throws -> Foo {
//        return Foo(
//            f1: try decodeJSON(j["f1"]) as F1,
//            f2: try decodeJSON(j["f2"]) as F2,
//        )
//    }
    func fieldToTokens(f: StructFieldSchema) -> StringList {
        return ["\(f.name): try decodeJSON(j[\"\(f.name)\"]) as \(typeIDToStringList(f.type).stringify()),"]
    }
    return [
        "func decodeJSON(j: JSONDictionary) throws", "->", k.name, "{",
            "return", k.name, "(",
                k.fields.map(fieldToTokens).toStringList(),
            ")",
        "}",
    ]
}



func tupleSchemaToTokens(k: TupleSchema) -> StringList {
    func tupleElementToTokens(t: TupleElement) -> StringList {
        if let n = t.name { return [n, typeIDToStringList(t.type)] }
        return [typeIDToStringList(t.type)]
    }
    return k.elements.map(tupleElementToTokens).toStringList()
}
























