//
//  File.swift
//  
//
//  .
//

import Foundation


public class TableBuilder {
    
    
    public func build(from grammar: Grammar) -> ParseTable {
        let heading = makeHeading(for: grammar)
        print(makeItemSets(in: grammar, with: heading).1)
        return .init(heading: heading, rows: [])
    }
    
    
    //Adds augmentations to the kernel of an item set
    public func addAugmentations(to items: [ParseItem], in grammar: Grammar) -> [ParseItem] {
        var result = items
        for item in items {
            if item.dot < item.lhs.count {
                let following = item.lhs[item.dot]
                let augmentation = grammar.rules.filter { i in
                    i.rhs == following
                }.map { i in
                    return ParseItem(id: i.id, rhs: i.rhs, lhs: i.lhs, dot: 0)
                }.filter { i in
                    !result.contains(i)
                }
                result.append(contentsOf: augmentation)
            }
            
        }
        
        return result
    }
    
    
    //Loops `addAugmentations()` and outputs generated item set
    public func makeItemSet(for items: [ParseItem], in grammar: Grammar, id: Int) -> ItemSet {
        var lenght = items.count
        var augmented = addAugmentations(to: items, in: grammar)
        while lenght != augmented.count {
            lenght = augmented.count
            augmented = addAugmentations(to: augmented, in: grammar)
        }
            
        return ItemSet(id: id, items: augmented)
    }
    
    
    
    // creates an array of item sets from a grammar and a shift table.
    public func makeItemSets(in grammar: Grammar, with header: [GrammarRuleItem: Int]) -> ([ItemSet], ParseTable) {
        
        var shiftTable = ParseTable(heading: header, rows: [])
        
        let zeroSet = makeItemSet(for: [.init(rule: grammar.augmentation)], in: grammar, id: 0)
        shiftTable.rows.append(.init(repeating: .error, count: header.count))
        
        
        var sets = [zeroSet]
        var lastIterationSets = [zeroSet]
        var newIterationSets = [ItemSet]()
        var idCounter = 1
            
        for itemSet in lastIterationSets {
            
            let followings = itemSet.items.compactMap { i -> GrammarRuleItem? in
                if i.lhs.count <= i.dot {
                    return nil
                }
                
                return i.lhs[i.dot]
            }.removingDuplicates()
            
            var newKernels = [([ParseItem], GrammarRuleItem)]()
            for following in followings {
                let items = itemSet.items.filter { i in
                    return i.lhs[i.dot] == following
                }
                newKernels.append((items, following))
            }
            
            for (newKernel, f) in newKernels {
                let shiftedNewKernel = newKernel.map { i -> ParseItem in
                    var j = i
                    j.dot += 1
                    return j
                }
                if f != .eof {
                    sets.append(makeItemSet(for: shiftedNewKernel, in: grammar, id: idCounter))
                    newIterationSets.append(makeItemSet(for: shiftedNewKernel, in: grammar, id: idCounter))
                    //make shift table
                    shiftTable.rows.append(.init(repeating: .error, count: header.count))
                    shiftTable.rows[itemSet.id][header[f]!] = .shift(idCounter)
                } else {
                    // add accept
                    shiftTable.rows[itemSet.id][header[f]!] = .accept
                }
                idCounter += 1
            }
        }
        
        
        while newIterationSets.count != 0 {
            
            lastIterationSets = newIterationSets
            newIterationSets = []
                
            for itemSet in lastIterationSets {
                let followings = itemSet.items.compactMap { i -> GrammarRuleItem? in
                    if i.lhs.count <= i.dot {
                        return nil
                    }
                    return i.lhs[i.dot]
                }.removingDuplicates()
                
                var newKernels = [([ParseItem], GrammarRuleItem)]()
                for following in followings {
                    let items = itemSet.items.filter { i in
                        return i.lhs[i.dot] == following
                    }
                    newKernels.append((items, following))
                }
                
                for (newKernel, f) in newKernels {
                    let shiftedNewKernel = newKernel.map { i -> ParseItem in
                        var j = i
                        j.dot += 1
                        return j
                    }
                    
                    if f != .eof {
                        sets.append(makeItemSet(for: shiftedNewKernel, in: grammar, id: idCounter))
                        newIterationSets.append(makeItemSet(for: shiftedNewKernel, in: grammar, id: idCounter))
                        //make shift table
                        shiftTable.rows.append(.init(repeating: .error, count: header.count))
                        shiftTable.rows[itemSet.id][header[f]!] = .shift(idCounter)
                    } else {
                        //add accept
                        shiftTable.rows[itemSet.id][header[f]!] = .accept
                    }
                    
                    idCounter += 1
                }
            }
        }
        
        
        return (sets, shiftTable)
    }
    
    
    
    func makeHeading(for grammar: Grammar) -> [GrammarRuleItem: Int] {
        var ruleItems = [GrammarRuleItem]()
        for rule in grammar.rules {
            var items = [rule.rhs] + rule.lhs
            items.removeDuplicates()
            ruleItems.append(contentsOf: items)
        }
        ruleItems.removeDuplicates()
        var c = 0
        var dictionary = [GrammarRuleItem:Int]()
        for ruleItem in ruleItems {
            dictionary[ruleItem] = c
            c += 1
        }
        dictionary[.eof] = dictionary.count
        return dictionary
    }
}
