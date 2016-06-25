//
//  Serialize.swift
//  DTOSerializationGenerator
//
//  Created by Hoon H. on 2016/06/24.
//  Copyright © 2016 Eonil. All rights reserved.
//

func generateFunctionToEncodeSchema(k: Schema) -> StringList {
    func entityToStringList(e: Entity) -> StringList {
        switch e {
        case .`enum`(let k):
            switch k.isParametric {
            case false: return generateFunctionToEncodeParameterlessEnumIntoJSONString(k)
            case true:  return generateFunctionToEncodeParametricEnumIntoJSONArray(k)
            }
        case .`struct`(let k):
            return generateFunctionToEncodeStructIntoJSONDictionary(k)
        }
    }
    return k.entities.map(entityToStringList).toStringList()
}

func generateFunctionToEncodeStructIntoJSONDictionary(k: StructSchema) -> StringList {
    guard k.fields.count > 0 else {
//        func encodeJSON(value: Foo) -> JSONValue {
//            return encodeJSON([:])
//        }
        return ["func encodeJSON(value: Foo) -> JSONValue {", "return encodeJSON([:])", "}"]
    }
//    func encodeJSON(value: Foo) -> JSONValue {
//        return encodeJSON([
//            encodeJSON("bar"):  encodeJSON(value.bar),
//            encodeJSON("baz"):  encodeJSON(value.baz),
//        ])
//    }
    func fieldToStringList(f: StructFieldSchema) -> StringList {
        return ["encodeJSON(\"\(f.name)\"): encodeJSON(value.\(f.name)),"]
    }
    return [
        "func encodeJSON(value: \(k.name)) -> JSONValue {",
            "return encodeJSON([",
                k.fields.map(fieldToStringList).toStringList(),
            "])",
        "}",
    ]
}
func generateFunctionToEncodeTupleIntoJSONArray(k: TupleSchema) -> StringList {
//    func encodeJSON(value: (f1: F1, F2, F3)) -> JSONValue {
//        return encodeJSON([
//            encodeJSON(value.f1),
//            encodeJSON(value.1),
//            encodeJSON(value.2),
//        ])
//    }
    func elementToStringList(index: Int, e: TupleElement) -> StringList {
        if let n = e.name { return ["encodeJSON(value.\(n))"] }
        return ["encodeJSON(value.\(index))"]
    }
    return [
        "func encodeJSON(value: (f1: F1, F2, F3)) -> JSONValue {",
            "return encodeJSON([",
                k.elements.enumerate().map(elementToStringList).toStringList(),
            "])",
        "}",
    ]
}
func generateFunctionToEncodeParameterlessEnumIntoJSONString(k: EnumSchema) -> StringList {
//    func encodeJSON(value: Foo) -> JSONValue {
//        switch value {
//        case f1: return encodeJSON("a1")
//        case f2: return encodeJSON("a1")
//    }
    func caseToStringList(c: EnumCaseSchema) -> StringList {
        return ["case .\(c.name): return encodeJSON(\"\(c.name)\")"]
    }
    return [
        "func encodeJSON(value: \(k.name)) -> JSONValue {",
            "switch value {",
                k.cases.map(caseToStringList).toStringList(),
            "}",
        "}",
    ]
}
func generateFunctionToEncodeParametricEnumIntoJSONArray(k: EnumSchema) -> StringList {
//    func encodeJSON(value: Foo) -> JSONValue {
//        switch value {
//        case f1(let a1, let a2): 
//            return encodeJSON([
//                encodeJSON(a1),
//                encodeJSON(a1),
//            ])
//        }
//        case f2(let a1, let a2):
//            return encodeJSON([
//                encodeJSON(a1),
//                encodeJSON(a1),
//            ])
//        }
//    }
    func bindingToStringList(index: Int, _: EnumParameter) -> StringList {
        return ["let arg\(index)"]
    }
    func elementToStringList(index: Int, _: EnumParameter) -> StringList {
        return ["encodeJSON(arg\(index))"]
    }
    func caseToStringList(c: EnumCaseSchema) -> StringList {
        let bindings = c.parameters.enumerate().map(bindingToStringList).map{ $0.stringify() }.joinWithSeparator(", ")
        let elements = c.parameters.enumerate().map(elementToStringList).map{ $0.stringify() }.joinWithSeparator(", ")
        return ["case .\(c.name)(\(bindings)): return encodeJSON([\(elements)])"]
    }
    return [
        "func encodeJSON(value: \(k.name)) -> JSONValue {",
            "switch value {",
                k.cases.map(caseToStringList).toStringList(),
            "}",
        "}",
    ]
}

















