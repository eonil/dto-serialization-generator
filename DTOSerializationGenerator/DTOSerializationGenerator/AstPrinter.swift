//
//  ASTPrinter.swift
//  DTOSerializationGenerator
//
//  Created by Hoon H. on 2016/06/24.
//  Copyright © 2016 Eonil. All rights reserved.
//

//private let LET = Token.letKeyword
//private let VAR = Token.varKeyword
//private let IF = Token.ifKeyword
//private let ELSE = Token.elseKeyword
//private let SWITCH = Token.switchKeyword
//private let CASE = Token.caseKeyword
//private let ASSIGN = Token.assignOp
//private let EQ = Token.equalityOp
//private let OPEN_BLOCK = Token.openingBrace
//private let CLOSING_BLOCK = Token.closingBrace
//
//enum Token {
//    case rawCode(String)
//    case comment(content: String)
//    case letKeyword
//    case varKeyword
//    case ifKeyword
//    case elseKeyword
//    case switchKeyword
//    case caseKeyword
//    case assignOp
//    case equalityOp
//    case openingBrace
//    case closingBrace
//}
//
//enum Token: TokenType, StringLiteralConvertible, UnicodeScalarLiteralConvertible, ExtendedGraphemeClusterLiteralConvertible {
//    case rawCode(String)
//    case lineComment(content: String)
//    case letKeyword
//    case varKeyword
//    case ifKeyword
//    case elseKeyword
//    case switchKeyword
//    case caseKeyword
//    case assignOp
//    case equalityOp
//    case openingBrace
//    case closingBrace
//
//    init(_ s: String) {
//        self = .rawCode(s)
//    }
//    init(stringLiteral value: String) {
//        self = .rawCode(value)
//    }
//    init(unicodeScalarLiteral value: UnicodeScalar) {
//        self = .rawCode(String(value))
//    }
//    init(extendedGraphemeClusterLiteral value: Character) {
//        self = .rawCode(String(value))
//    }
//}
//protocol ASTDetokenizable {
//    func detokenize() -> TokenList
//}
//extension String: ASTDetokenizable {
//    func detokenize() -> TokenList {
//        return [self]
//    }
//}
//extension Array where Element: ASTDetokenizable {
//    func detokenize() -> TokenList {
//        let a: [TokenType] = map { $0.detokenize() }
//        return TokenList(a)
//    }
//}
//extension Optional where Wrapped: ASTDetokenizable {
//    func detokenize() -> TokenList {
//        if let some = self { return [some.detokenize()] }
//        return []
//    }
//}
//
//extension ASTBlock: ASTDetokenizable {
//    func detokenize() -> TokenList {
//        return ["{", sections.detokenize(), "}"]
//    }
//}
//extension ASTBlockSection: ASTDetokenizable {
//    func detokenize() -> TokenList {
//        switch self {
//        case .comment(let s):
//            return [s]
//        case .rawCode(let s):
//            return [s]
//        case .statement(let statement):
//            return statement.detokenize()
//        case .subblock(let subblock):
//            return subblock.detokenize()
//        }
//    }
//}
//extension ASTExpression: ASTDetokenizable {
//    func detokenize() -> TokenList {
//        switch self {
//        case let .valueName(n):
//            return ["`", n, "`"]
//        case .funcCall(let valueSource, let parameterBindings):
//            return [valueSource.detokenize(), "(", parameterBindings.detokenize(), ")"]
//        case .enumCase(let name, let parameterBindings):
//            let tks = parameterBindings.map {
//                return ["let", $0]
//            }.joinWithSeparator([", "]).map { $0 as TokenType }
//            return ["case", name.detokenize(), "(", TokenList(tks), ")",  ":"]
//        case .memberOf(let valueSource, let memberName):
//            return [valueSource.detokenize(), "=" , memberName.detokenize()]
//        case .rawCode(let s):
//            return [s]
//        }
//    }
//}
//extension ASTFuncParamBindingExpr: ASTDetokenizable {
//    func detokenize() -> TokenList {
//        return [label.detokenize(), ":", value.detokenize()]
//    }
//}
//extension ASTStatement: ASTDetokenizable {
//    func detokenize() -> TokenList {
//        switch self {
//        case .letAssign(let valueName, let source):
//            return ["let", valueName.detokenize(), "=", source.detokenize()]
//        case .varAssign(let valueName, let source):
//            return ["let", valueName.detokenize(), "=", source.detokenize()]
//        case .assignment(let destination, let source):
//            return [destination.detokenize(), "=", source.detokenize()]
//        case .forIn(let elementName, let range, let body):
//            return ["for", elementName.detokenize(), "in", range.detokenize(), body.detokenize()]
//        case .guardCompare(let comparison, let elseBody):
//            return ["guard", comparison.detokenize(), "else", elseBody.detokenize()]
//        case .guardLet(let variableName, let source, let elseBody):
//            return ["guard", "let", variableName.detokenize(), "=", source.detokenize(), "else", elseBody.detokenize()]
//        case .ifCompare(let comparison, let body, let elseBody):
//            func getElseBody() -> TokenList {
//                if let elseBody = elseBody { return ["else", elseBody.detokenize()] }
//                return []
//            }
//            return ["if", comparison.detokenize(), body.detokenize(), getElseBody()]
//        case .ifLet(let variableName, let source, let body, let elseBody):
//            func getElseBody() -> TokenList {
//                if let elseBody = elseBody { return ["else", elseBody.detokenize()] }
//                return []
//            }
//            return ["if", "let", variableName.detokenize(), "=", source.detokenize(), getElseBody()]
//        case .returnResult(let expr):
//            return ["return", expr.detokenize()]
//        case .switchBranch(let condition, let caseSections):
//            return ["switch", condition.detokenize(), "{", caseSections.detokenize(), "}"]
//        }
//    }
//}
//extension ASTCaseSection: ASTDetokenizable {
//    func detokenize() -> TokenList {
//        switch self {
//        case .caseIs(let expr, let body):
//            return ["case", "is", expr.detokenize(), ":", body.detokenize()]
//        case .caseValue(let expr, let body):
//            return ["case", expr.detokenize(), ":", body.detokenize()]
//        }
//    }
//}
//protocol ASTPrintable {
//    func printTo(p: ASTPrinter)
//}
//
//struct ASTPrinter {
//    var indentationUnit = "    "
//    var depth = 0
//    func writeRawCode(s: String) {
//
//    }
//    func writeLineOfRawCode(s: String) {
//
//    }
//    private mutating func pushDepth() {
//        depth += 1
//    }
//    private mutating func popDepth() {
//        depth -= 1
//    }
//    mutating func writeWithIndentingBlock(@noescape f: () -> ()) {
//        pushDepth()
//        f()
//        popDepth()
//    }
//}
//struct NestingPrinter {
//    private var indentUnit = "    "
//    private var depth = 0
//    mutating func pushDepth() {
//        depth += 1
//    }
//    mutating func popDepth() {
//        depth -= 1
//    }
//    func printLine(s: String, to: Writer) {
//
//    }
//}
//struct LinePrinter {
//    func printLine(s: String, to: Writer) {
//
//    }
//}
//
//typealias Writer = String -> ()
