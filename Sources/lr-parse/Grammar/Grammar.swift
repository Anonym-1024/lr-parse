



public struct Grammar: CustomStringConvertible {
    public var description: String{
        "rules: \n \(rules) \n \n augmentation: \n \(augmentation)"
    }
    var rules: [GrammarRule]
    
    var augmentation: GrammarRule {
        guard let first = rules.first?.rhs else { return .init(id: 0, rhs: .nonTerminal(""), lhs: [.eof]) }
        return .init(id: 0, rhs: .nonTerminal(""), lhs: [first, .eof])
    }
}
