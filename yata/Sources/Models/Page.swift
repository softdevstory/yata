//
//  Page.swift
//  yata
//
//  Created by HS Song on 2017. 6. 14..
//  Copyright © 2017년 HS Song. All rights reserved.
//

import Foundation
import ObjectMapper

/**

 This object represents a page on Telegraph.

 */
class Page: Mappable {

    /// path (String) - Path to the page.
    var path: String?
    
    /// url (String) - URL of the page.
    var url: String?
    
    /// title (String)- Title of the page.
    var title: String?
    
    /// description (String) - Description of the page.
    var description: String?
    
    /// author_name (String) - Optional. Name of the author, displayed below the title.
    var authorName: String?
    
    /// author_url (String) - Optional. Profile link, opened when users click on the author's name below the title.  Can be any link, not necessarily to a Telegram profile or channel.
    var authorUrl: String?
    
    /// image_url (String) - Optional. Image URL of the page.
    var imageUrl: String?
    
    /// content (Array of Node) - Optional. Content of the page.
    var content: [Node]?
    
    /// views (Integer) - Number of page views for the page.
    var views: Int?
    
    /// can_edit (Boolean) - Optional. Only returned if access_token passed. True, if the target Telegraph account can edit the page.
    var canEdit: Bool?

    required init?(map: Map) {

    }
    
    func mapping(map: Map) {
        path        <- map["path"]
        url         <- map["url"]
        title       <- map["title"]
        description <- map["description"]
        authorName  <- map["author_name"]
        authorUrl   <- map["author_url"]
        imageUrl    <- map["image_url"]
        content     <- (map["content"], NodeArrayTransform())
        views       <- map["views"]
        canEdit     <- map["can_edit"]
    }
}
