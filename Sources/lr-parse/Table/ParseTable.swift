//
//  File.swift
//  
//
//
//

import Foundation

public struct ParseTable: CustomStringConvertible {
    public var heading: [GrammarRuleItem: Int]
    public var rows: [[TableItem]]
    public var description: String{
        "\(heading)\n\n\n\(rows)"
    }
    public enum TableItem {
        case shift(Int)
        case reduce(Int)
        case error
        case accept
    }
}
