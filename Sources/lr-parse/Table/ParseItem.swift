//
//  File.swift
//  
//
//  Created by Vašík Koukola on 05.02.2023.
//

import Foundation

public struct ParseItem: Hashable {
    public init(id: Int, rhs: GrammarRuleItem, lhs: [GrammarRuleItem], dot: Int/*, nextState: Int*/) {
        self.id = id
        self.rhs = rhs
        self.lhs = lhs
        self.dot = dot
        //self.nextState = nextState
    }
    
    public init(rule: GrammarRule) {
        self.id = rule.id
        self.rhs = rule.rhs
        self.lhs = rule.lhs
        self.dot = 0
        //self.nextState = 0
    }
    
    public var id: Int
    //public var nextState: Int
    public var rhs: GrammarRuleItem
    public var lhs: [GrammarRuleItem]
    public var dot: Int
}
