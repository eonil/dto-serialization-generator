//
//  Schema.swift
//  DTOSerializationGenerator
//
//  Created by Hoon H. on 2016/06/23.
//  Copyright © 2016 Eonil. All rights reserved.
//

struct Schema {
    var entities: [Entity]
    public static var a = 1
}

enum Entity {
    case `enum`(EnumSchema)
    case `struct`(StructSchema)
}
typealias EntityID = String

/// Tuple is a name-less struct, and its fields also have no name.
struct TupleSchema {
    var elements: [TupleElement]
}
struct TupleElement {
    var name: String?
    var type: TypeID
}

struct EnumSchema {
    var name: String
    var cases: [EnumCaseSchema]

    var isParametric: Bool {
        for c in cases {
            if c.parameters.count > 0 { return true }
        }
        return false
    }
}
struct EnumCaseSchema {
    var name: String
    var parameters: [EnumParameter]
}
struct EnumParameter {
    var name: String?
    var type: TypeID
}

struct StructSchema {
    var name: String
    var fields: [StructFieldSchema]
}
struct StructFieldSchema {
    var name: String
    var type: TypeID
}

enum TypeID {
    indirect case arrayOf(TypeID)
    indirect case optionalOf(TypeID)
    case entity(EntityID)
    case tuple(TupleSchema)
    case atom(AtomTypeID)
}
enum AtomTypeID {
    case int8, int16, int32, int64
    case uint8, uint16, uint32, uint64
    case float32, float64
    case string
}














