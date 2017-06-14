//
//  NodeElement.swift
//  yata
//
//  Created by HS Song on 2017. 6. 13..
//  Copyright © 2017년 HS Song. All rights reserved.
//

import Foundation
import ObjectMapper

class NodeElement: Mappable {
   
    var tag: String?
    var attrs: Attrs?
    var children: [Node]?
    
    required init?(map: Map) {

    }
    
    func mapping(map: Map) {
        tag         <- map["tag"]
        attrs       <- map["attrs"]
        
        if let list = map["children"].currentValue as? [Any], list.count > 0 {
            children = []
            
            for item in list {
                let node: Node
                
                if let string = item as? String {
                    node = Node(string: string)
                    children?.append(node)
                } else if let dict = item as? [String: Any] {
                    if let nodeElement = NodeElement(JSON: dict) {
                        node = Node(element: nodeElement)
                        children?.append(node)
                    }
                }
            }
        }
    }
}
