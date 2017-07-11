//
//  NodeElement.swift
//  yata
//
//  Created by HS Song on 2017. 6. 13..
//  Copyright © 2017년 HS Song. All rights reserved.
//

import Foundation
import ObjectMapper

/**

 This object represents a DOM element node.
 
 */
class NodeElement: Mappable {

    /// tag (String) - Name of the DOM element. Available tags: a, aside, b, blockquote, br, code, em, figcaption, figure, h3, h4, hr, i, iframe, img, li, ol, p, pre, s, strong, u, ul, video.
    var tag: String?
    
    /// attrs (Object) - Optional. Attributes of the DOM element. Key of object represents name of attribute, value represents value of attribute. Available attributes: href, src.
    var attrs: Attrs?
    
    /// children (Array of Node) - Optional. List of child nodes for the DOM element.
    var children: [Node]?
    
    required init?(map: Map) {

    }

    init() {
        // nothing
    }
    
    func mapping(map: Map) {
        tag         <- map["tag"]
        attrs       <- map["attrs"]
        
        children <- (map["children"], NodeArrayTransform())
    }
}

extension NodeElement {
    
    var string: String {
    
        var result = ""
        
        if let children = children {
            for node in children {
                result.append(node.string)
            }
        }
        
        if let tag = tag {
            switch tag {
            case "br", "p":
                result.append("\n")
            default:
                break
            }
        }
        
        return result
    }
}
