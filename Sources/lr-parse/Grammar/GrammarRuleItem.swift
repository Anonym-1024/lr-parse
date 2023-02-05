//
//  File.swift
//  
//
//
//

import Foundation


public enum GrammarRuleItem: Hashable {
    case terminal(String)
    case nonTerminal(String)
    case kind(String)
    case eof
}
