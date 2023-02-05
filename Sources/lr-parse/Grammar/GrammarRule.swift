//
//  File.swift
//  
//
//  
//

import Foundation


public struct GrammarRule: CustomStringConvertible, Equatable {
    public var description: String{
        "\(id): \(rhs) -> \(lhs) (\(lenght)) \n"
    }
    var id: Int
    var rhs: GrammarRuleItem
    var lhs: [GrammarRuleItem]
    var lenght: Int {
        lhs.count
    }
}
