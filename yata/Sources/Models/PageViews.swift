//
//  PageViews.swift
//  yata
//
//  Created by HS Song on 2017. 6. 13..
//  Copyright © 2017년 HS Song. All rights reserved.
//

import Foundation
import ObjectMapper

class PageViews: Mappable {
    var views: Int?

    required init?(map: Map) {
    
    }
    
    func mapping(map: Map) {
        views <- map["views"]
    }
}
