//
//  Account.swift
//  yata
//
//  Created by HS Song on 2017. 6. 13..
//  Copyright © 2017년 HS Song. All rights reserved.
//

import Foundation
import ObjectMapper

class Account: Mappable {
    var shortName: String?
    var authorName: String?
    var authorUrl: String?
    var accessToken: String?
    var authUrl: String?
    var pageCount: Int?

    required init?(map: Map) {
    
    }
    
    func mapping(map: Map) {
        shortName   <- map["short_name"]
        authorName  <- map["author_name"]
        authorUrl   <- map["author_url"]
        accessToken <- map["access_token"]
        authUrl     <- map["auth_url"]
        pageCount   <- map["page_count"]
    }
}
