//
//  Runtie.swift
//  DTOSerializationGenerator
//
//  Created by Hoon H. on 2016/06/25.
//  Copyright © 2016 Eonil. All rights reserved.
//

import Foundation

// For now, I am using OBJC classes intentionally because first targeting 
// system(macOS/Cocoa)'s default JSON serialization system is
// `NSJSONSerialization`, which uses only OBJC classes internally.
// This will be changed as soon as I find out a nice JSON library to 
// support another *nix/Windows target.

typealias JSONValue = protocol<NSObjectProtocol, NSCopying>
typealias JSONArray = NSArray
typealias JSONObject = NSDictionary
typealias JSONString = NSString
typealias JSONNumber = NSNumber

func encodeJSON(value: Int8) -> JSONValue {
    return NSNumber(char: value)
}
func encodeJSON(value: Int16) -> JSONValue {
    return NSNumber(short: value)
}
func encodeJSON(value: Float32) -> JSONValue {
    return NSNumber(float: value)
}
func encodeJSON(value: Float64) -> JSONValue {
    return NSNumber(double: value)
}
func encodeJSON(value: String) -> JSONValue {
    return value
}
//func encodeJSON(value: [JSONValue]) -> JSONValue {
//    return NSArray(array: value)
//}
//func encodeJSON(value: [JSONString: JSONValue]) -> JSONValue {
//    return NSDictionary(dictionary: value)
//}
func encodeJSON(value: NSArray) -> JSONValue {
    return value
}
func encodeJSON(value: NSDictionary) -> JSONValue {
    return value
}
















