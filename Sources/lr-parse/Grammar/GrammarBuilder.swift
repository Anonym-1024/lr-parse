//
//  File.swift
//  
//
//  Created by Vašík Koukola on 05.02.2023.
//

import Foundation

public class GrammarBuilder {
    
    
    func build(from: String) throws -> Grammar {
        var string = from.trimmingCharacters(in: .whitespacesAndNewlines)
        var ruleLines = string.components(separatedBy: "\n")
        var rules = [GrammarRule]()
        var id = 0
        for line in ruleLines {
            id += 1
            var components = line.components(separatedBy: " ")
            let index = components.firstIndex(of: "->")
            guard index == 1 else { throw  BuildError.invalidFormat(3)}
            guard components[0].hasPrefix("<") && components[0].hasSuffix(">") else { throw BuildError.invalidFormat(0) }
            let rhs = GrammarRuleItem.nonTerminal(components[0].trimmingCharacters(in: .init(arrayLiteral: "<", ">")))
            components.removeFirst(2)
            guard components.count != 0 else { throw BuildError.invalidFormat(1) }
            var lhs = [GrammarRuleItem]()
            for component in components {
                if component.hasPrefix(".") {
                    lhs.append(.kind(String(component.dropFirst(1))))
                } else if component.hasPrefix("<") && component.hasSuffix(">") {
                    lhs.append(.nonTerminal(component.trimmingCharacters(in: .init(arrayLiteral: "<", ">"))))
                } else {
                    lhs.append(.terminal(component))
                }
            }
            
            let rule = GrammarRule(id: id, rhs: rhs, lhs: lhs)
            rules.append(rule)
        }
        
        let grammar = Grammar(rules: rules)
        return grammar
    }
    
    enum BuildError: Error {
        case invalidFormat(Int)
    }
}
