//
//  File.swift
//  
//
//  Created by Vašík Koukola on 05.02.2023.
//

import Foundation




try! TableBuilder().build(from: GrammarBuilder().build(from: """
<main> -> <statements> main
<statements> -> var

"""))
