//
//  DTOSerializationGeneratorUnitTests.swift
//  DTOSerializationGeneratorUnitTests
//
//  Created by Hoon H. on 2016/06/24.
//  Copyright © 2016 Eonil. All rights reserved.
//

import Foundation
import XCTest

/// Many tests run `swiftc` using external Bash subprocess.
///
class DTOSerializationGeneratorUnitTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testSwiftCompilerVersion() {
        let (_, e, _) = try! run("swiftc -v")
        // For now, I support only current version.
        XCTAssert(e.containsString("Apple Swift version 2.2"))
    }
    func testCompilabilityOfParameterlessEnum() throws {
        enum Error: ErrorType {
            case missingTempFilePathInURL(NSURL)
        }
        let k = Schema(entities: [
            Entity.`enum`(EnumSchema(name: "E1", cases: [
                EnumCaseSchema(name: "c1", parameters: [])
            ])),
            ])
        let c = generateFunctionToEncodeSchema(k).stringify()
        let fu = try generateDTOCoderSourceFile(code: c)
        guard let fp = fu.path else { throw Error.missingTempFilePathInURL(fu) }
        let sfps = try testSupportFilePathsExpression()
        let (o, e, x) = try! run("swiftc \(fp) \(sfps)")
        print((o, e, x))
        XCTAssert(e == "")
        XCTAssert(o == "")
    }
    func testCompilabilityOfParameticEnum() throws {
        enum Error: ErrorType {
            case missingTempFilePathInURL(NSURL)
        }
        let k = Schema(entities: [
            Entity.`enum`(EnumSchema(name: "E2", cases: [
                EnumCaseSchema(name: "c1", parameters: [
                    EnumParameter(name: "p1", type: .atom(.int8)),
                    EnumParameter(name: "p2", type: .atom(.float32)),
                    EnumParameter(name: "p3", type: .atom(.string)),
                ]),
            ])),
            ])
        let c = generateFunctionToEncodeSchema(k).stringify()
        let fu = try generateDTOCoderSourceFile(code: c)
        guard let fp = fu.path else { throw Error.missingTempFilePathInURL(fu) }
        let sfps = try testSupportFilePathsExpression()
        let (o, e, x) = try! run("swiftc \(fp) \(sfps)")
        print((o, e, x))
        XCTAssert(e == "")
        XCTAssert(o == "")
    }
    func testCompilabilityOfStruct() throws {
        enum Error: ErrorType {
            case missingTempFilePathInURL(NSURL)
        }
        let k = Schema(entities: [
            Entity.`struct`(StructSchema(name: "S3", fields: [
                StructFieldSchema(name: "f1", type: .atom(.int16)),
                StructFieldSchema(name: "f2", type: .atom(.float64)),
                StructFieldSchema(name: "f3", type: .atom(.string)),
                ])),
            ])
        let c = generateFunctionToEncodeSchema(k).stringify()
        let fu = try generateDTOCoderSourceFile(code: c)
        guard let fp = fu.path else { throw Error.missingTempFilePathInURL(fu) }
        let sfps = try testSupportFilePathsExpression()
        let (o, e, x) = try! run("swiftc \(fp) \(sfps)")
        print((o, e, x))
        XCTAssert(e == "")
        XCTAssert(o == "")
    }

    ////

    private func generateDTOCoderSourceFile(code c: String) throws -> NSURL {
        enum Error: ErrorType {
            case cannotBuildParentDirectoryURLFromFileURL(NSURL)
            case cannotEncodeSourceCodeUsingUTF8(String)
        }
        let fu = getTempDirectoryURL().URLByAppendingPathComponent("main.swift", isDirectory: false)
        guard let du = fu.URLByDeletingPathExtension else { throw Error.cannotBuildParentDirectoryURLFromFileURL(fu) }
        try NSFileManager.defaultManager().createDirectoryAtURL(du, withIntermediateDirectories: true, attributes: [:])
        guard let d = c.dataUsingEncoding(NSUTF8StringEncoding) else { throw Error.cannotEncodeSourceCodeUsingUTF8(c) }
        let ok = d.writeToURL(fu, atomically: true)
        XCTAssert(ok)
        return fu
    }
    private func testSupportFilePathsExpression() throws -> String {
        enum Error: ErrorType {
            case missingPathInURL(NSURL)
        }
        return try getSupportSourceFileLocations().map { (u: NSURL) throws -> String in
            guard let p = u.path else { throw Error.missingPathInURL(u) }
            return p
        }.joinWithSeparator(" ")
    }
    private func run(command: String) throws -> (output: String, error: String, exit: Int32) {
        return try runUsingBash([command, "exit 0;"])
    }
}
