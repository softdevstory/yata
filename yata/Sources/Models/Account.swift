//
//  Account.swift
//  yata
//
//  Created by HS Song on 2017. 6. 13..
//  Copyright © 2017년 HS Song. All rights reserved.
//

import Foundation
import ObjectMapper

/**

 This object represents a Telegraph account.
 
 */
class Account: Mappable {

    /// short_name (String) - Account name, helps users with several accounts remember which they are currently using. Displayed to the user above the "Edit/Publish" button on Telegra.ph, other users don't see this name.
    var shortName: String?
    
    /// author_name (String) - Default author name used when creating new articles.
    var authorName: String?
    
    /// author_url (String) - Profile link, opened when users click on the author's name below the title. Can be any link, not necessarily to a Telegram profile or channel.
    var authorUrl: String?
    
    /// access_token (String) - Optional. Only returned by the createAccount and revokeAccessToken method. Access token of the Telegraph account.
    var accessToken: String?
    
    /// auth_url (String) - Optional. URL to authorize a browser on telegra.ph and connect it to a Telegraph account. This URL is valid for only one use and for 5 minutes only.
    var authUrl: String?
    
    /// page_count (Integer) - Optional. Number of pages belonging to the Telegraph account.
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
