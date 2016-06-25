////
////  AST.swift
////  DTOSerializationGenerator
////
////  Created by Hoon H. on 2016/06/23.
////  Copyright © 2016 Eonil. All rights reserved.
////
//
//struct AST {
//
//}
//
//struct ASTFile {
//
//}
//
//struct ASTFuncDef {
//    var name: String
//    var content: ASTAnonymousFuncDef
//}
//struct ASTAnonymousFuncDef {
//    var inputParams: [ASTFuncParam]
//    var outputParams: [ASTTupleExpr]
//    var body: ASTBlock
//}
//
//struct ASTFuncParam {
//    var label: String?
//    var name: String
//    var type: ASTTypeExpr
//}
//
//struct ASTBlock {
//    var sections: [ASTBlockSection]
//}
//enum ASTBlockSection {
//    /// Prints code as is.
//    case rawCode(String)
//    case comment(String)
//    case statement(ASTStatement)
//    indirect case subblock(ASTBlock)
//}
//enum ASTStatement {
//    case returnResult(ASTExpression)
//    case guardLet(variableName: ASTSymbolName, source: ASTExpression, elseBody: ASTBlock)
//    case guardCompare(comparison: ASTExpression, elseBody: ASTBlock)
//    case ifLet(variableName: ASTSymbolName, source: ASTExpression, body: ASTBlock, elseBody: ASTBlock?)
//    case ifCompare(comparison: ASTExpression, body: ASTBlock, elseBody: ASTBlock?)
//    case switchBranch(condition: ASTExpression, caseSections: [ASTCaseSection])
//    case forIn(elementName: ASTSymbolName, range: ASTExpression, body: ASTBlock)
//    case letAssign(valueName: ASTSymbolName, source: ASTExpression)
//    case varAssign(valueName: ASTSymbolName, source: ASTExpression)
//    case assignment(destination: ASTExpression, source: ASTExpression)
//}
//enum ASTCaseSection {
//    case caseIs(ASTExpression, body: ASTBlock)
//    case caseValue(ASTExpression, body: ASTBlock)
//}
//enum ASTExpression {
//    case rawCode(String)
//    case valueName(ASTSymbolName)
////    case anonymousFunc(ASTAnonymousFuncDef)
//    indirect case funcCall(valueSource: ASTExpression?, parameterBindings: [ASTFuncParamBindingExpr])
//    indirect case memberOf(valueSource: ASTExpression, memberName: ASTSymbolName)
//    case enumCase(name: ASTSymbolName, parameterBindings: [ASTSymbolName])
//}
//struct ASTFuncParamBindingExpr {
//    var label: String?
//    var value: ASTExpression
//}
//
//struct ASTTupleExpr {
//    var elements: [(name: String?, value: ASTExpression)]
//}
//
//enum ASTTypeExpr {
//    case rawCode(String)
//    case schema(TypeID)
//}
////enum ASTTypeExpr {
////    indirect case arrayOf(ASTTypeExpr)
////    indirect case optionalOf(ASTTypeExpr)
////    case tuple(elements: [ASTTupleElement])
////    case `struct`(name: String)
////    case `enum`(name: String)
////}
//
//typealias ASTSymbolName = String
//
//
//
//
//
//
//
//
//
//
//
//
//
//
