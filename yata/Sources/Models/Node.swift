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

/**

 This abstract object represents a DOM Node. It can be a String which represents a DOM text node or a NodeElement object.
 
 */
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


class NodeArrayTransform: TransformType {
    typealias Object = [Node]
	typealias JSON = [Any]
	
    func transformFromJSON(_ value: Any?) -> [Node]? {
        guard let list = value as? [Any], list.count > 0 else {
            return nil
        }
        
        var node: [Node] = []
        
        for item in list {
            if let string = item as? String {
                node.append(Node(string: string))
            } else if let dict = item as? [String: Any] {
                if let nodeElement = NodeElement(JSON: dict) {
                    node.append(Node(element: nodeElement))
                }
            }
        }
    
        return node
	}
	
	func transformToJSON(_ value: [Node]?) -> [Any]? {
        guard let list = value, list.count > 0 else { return nil }

        var json: [Any] = []
        for node in list {
            switch node.type {
            case .string:
                json.append(node.value)
            case .nodeElement:
                json.append(node.element.toJSON())
            }
        }
        
        return json
	}
}
