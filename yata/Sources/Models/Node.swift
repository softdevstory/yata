//
//  Node.swift
//  yata
//
//  Created by HS Song on 2017. 6. 13..
//  Copyright © 2017년 HS Song. All rights reserved.
//

import Foundation
import ObjectMapper

enum NodeType {
    case string
    case nodeElement
}

class Node {
    let type: NodeType
    
    let value: String!
    let element: NodeElement!
    
    init(string: String) {
        type = NodeType.string
        value = string
        element = nil
    }
    
    init(element: NodeElement) {
        type = NodeType.nodeElement
        value = nil
        self.element = element
    }
}
