//
//  PageViews.swift
//  yata
//
//  Created by HS Song on 2017. 6. 13..
//  Copyright © 2017년 HS Song. All rights reserved.
//

import Foundation
import ObjectMapper

/**

 This object represents the number of page views for a Telegraph article.
 
 */
class PageViews: Mappable {

    /// views (Integer) - Number of page views for the target page.
    var views: Int?

    required init?(map: Map) {
    
    }
    
    func mapping(map: Map) {
        views <- map["views"]
    }
}
