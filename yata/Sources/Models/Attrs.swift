//
//  Attrs.swift
//  yata
//
//  Created by HS Song on 2017. 6. 13..
//  Copyright © 2017년 HS Song. All rights reserved.
//

import Foundation
import ObjectMapper

class Attrs: Mappable {
    var href: String?
    var src: String?
    var id: String?
    var target: String?
    
    required init?(map: Map) {

    }
    
    func mapping(map: Map) {
        href    <- map["href"]
        src     <- map["src"]
        id      <- map["id"]
        target  <- map["target"]
    }
}
