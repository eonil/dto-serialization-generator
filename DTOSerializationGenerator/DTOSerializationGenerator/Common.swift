//
//  Common.swift
//  DTOSerializationGenerator
//
//  Created by Hoon H. on 2016/06/25.
//  Copyright © 2016 Eonil. All rights reserved.
//

func typeIDToStringList(t: TypeID) -> StringList {
    switch t {
    case .atom(let id):
        switch id {
        case .int8:     return ["Int8"]
        case .int16:    return ["Int16"]
        case .int32:    return ["Int32"]
        case .int64:    return ["Int64"]
        case .uint8:    return ["UInt8"]
        case .uint16:   return ["UInt16"]
        case .uint32:   return ["UInt32"]
        case .uint64:   return ["UInt64"]
        case .float32:  return ["Float"]
        case .float64:  return ["Double"]
        case .string:   return ["String"]
        }
    case .entity(let id):
        return [id]
    case .optionalOf(let t):
        return ["\(typeIDToStringList(t).stringify())?"]
    case .tuple(let k):
        return tupleSchemaToTokens(k)
    case .arrayOf(let t):
        return ["Array<\(typeIDToStringList(t).stringify())>"]
    }
}