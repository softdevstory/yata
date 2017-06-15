//
//  PageList.swift
//  yata
//
//  Created by HS Song on 2017. 6. 14..
//  Copyright © 2017년 HS Song. All rights reserved.
//

import Foundation
import ObjectMapper

/**

 This object represents a list of Telegraph articles belonging to an account. Most recently created articles first.
 
 */
class PageList: Mappable {

    /// total_count (Integer) - Total number of pages belonging to the target Telegraph account.
    var totalCount: Int?
    
    /// pages (Array of Page) - Requested pages of the target Telegraph account.
    var pages: [Page]?

    required init?(map: Map) {

    }
    
    func mapping(map: Map) {
        totalCount  <- map["total_count"]
        pages       <- map["pages"]
    }
}
