//
//  SourceFile.swift
//  SwiftDTOSerializationGenerator
//
//  Created by Hoon H. on 2016/05/20.
//  Copyright © 2016 Eonil. All rights reserved.
//

import Foundation

//extension Array {
//    func splitFirst() -> (Element, Array)? {
//        if let first = first { return (first, Array(self[0..<count])) }
//        fatalError()
//    }
//}
//func readSourceFile(atom: Atom) -> SourceFile? {
//    guard let list = atom.list else { return nil }
//    guard let (first, tail) = list.splitFirst() else { return nil }
//    guard first.value == "source_file" else { return nil }
//    var s = SourceFile()
//    for atom in tail {
//        if let structDecl = readStructDecl(atom) {
//            s.structDecls.append(structDecl)
//        }
//    }
//    return s
//}
//func readStructDecl(atom: Atom) -> StructDecl? {
//    guard let list = atom.list else { return nil }
//    guard list[0].value == "struct_decl" else { return nil }
//    var s = StructDecl()
//    s.name = list[1].value ?? ""
//    s.access = list[3].value ?? ""
//    for atom in list[4..<list.count] {
//        readVarDecl(atom).flatMap({ s.varDecls.append($0) })
//    }
//    return s
//}
//func readVarDecl(atom: Atom) -> VarDecl? {
//    guard let list = atom.list else { return nil }
//    guard list[0].value == "var_decl" else { return nil }
//    var s = VarDecl()
//    s.name = list[1].value ?? ""
//    s.type = list[2].value ?? ""
//    s.access = list[3].value ?? ""
//    return s
//}
//
//struct SourceFile {
//    var structDecls = [StructDecl]()
//}
//struct EnumDecl {
//    var name = ""
//    var caseDecls = [EnumCaseDecl]()
//}
//struct EnumCaseDecl {
//    
//}
//struct StructDecl {
//    var name = ""
//    var access = ""
//    var varDecls = [VarDecl]()
//}
//struct VarDecl {
//    var name = ""
//    var type = ""
//    var access = ""
//}




