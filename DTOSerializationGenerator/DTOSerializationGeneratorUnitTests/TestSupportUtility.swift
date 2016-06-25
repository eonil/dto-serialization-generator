//
//  TestSupportUtility.swift
//  DTOSerializationGenerator
//
//  Created by Hoon H. on 2016/06/25.
//  Copyright © 2016 Eonil. All rights reserved.
//

import Foundation

func getSupportSourceFileLocations() throws -> [NSURL] {
    enum Error: ErrorType {
        case missingRuntimeSourceFile
    }
    func getRuntimeDirectoryFile(fileName: String) throws -> NSURL {
        let p = #file
        let u = NSURL(fileURLWithPath: p, isDirectory: false)
        guard let u1 = u
            .URLByDeletingLastPathComponent?
            .URLByDeletingLastPathComponent?
            .URLByAppendingPathComponent("DTOSerializationGenerator", isDirectory: true)
            .URLByAppendingPathComponent(fileName, isDirectory: false) else { throw Error.missingRuntimeSourceFile }
        return u1
    }
    func getTestSampleDirectoryFile(fileName: String) throws -> NSURL {
        let p = #file
        let u = NSURL(fileURLWithPath: p, isDirectory: false)
        guard let u1 = u
            .URLByDeletingLastPathComponent?
            .URLByAppendingPathComponent(fileName, isDirectory: false) else { throw Error.missingRuntimeSourceFile }
        return u1
    }
    return [
        try getRuntimeDirectoryFile("Runtime.swift"),
        try getTestSampleDirectoryFile("TestSampleSchema.swift"),
    ]
}
func getTempDirectoryURL() -> NSURL {
    let us = NSProcessInfo.processInfo().globallyUniqueString
    let u = NSURL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
    let u1 = u.URLByAppendingPathComponent(us, isDirectory: true)
    return u1
}
func runUsingBash(lines: [String]) throws -> (output: String, error: String, exit: Int32) {
    enum Error: ErrorType {
        case cannotEncodeInputLineUsingUTF8(String)
        case cannotDecodeOutputDataUsingUTF8(NSData)
    }

    let inPipe = NSPipe()
    let outPipe = NSPipe()
    let errorPipe = NSPipe()
    let t = NSTask()
    t.standardInput = inPipe
    t.standardOutput = outPipe
    t.standardError = errorPipe
    t.launchPath = "/bin/bash"
    t.arguments = ["-s"]
    t.launch()
    for l in lines {
        let inputString = l + "\n"

        guard let inputData = (inputString as NSString).dataUsingEncoding(NSUTF8StringEncoding) else { throw Error.cannotEncodeInputLineUsingUTF8(l) }
        inPipe.fileHandleForWriting.writeData(inputData)
    }
    t.waitUntilExit()
    let exitCode = t.terminationStatus
    let outputData = outPipe.fileHandleForReading.readDataToEndOfFile()
    let errorData = errorPipe.fileHandleForReading.readDataToEndOfFile()
    guard let outputString = NSString(data: outputData, encoding: NSUTF8StringEncoding) as? String else { throw Error.cannotDecodeOutputDataUsingUTF8(outputData) }
    guard let errorString = NSString(data: errorData, encoding: NSUTF8StringEncoding) as? String else { throw Error.cannotDecodeOutputDataUsingUTF8(errorData) }
    return (outputString, errorString, exitCode)
}









