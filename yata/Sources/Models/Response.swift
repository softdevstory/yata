//
//  Response.swift
//  yata
//
//  Created by HS Song on 2017. 6. 15..
//  Copyright © 2017년 HS Song. All rights reserved.
//

import Foundation

enum ResponseType {
    case error
    case account
    case page
    case pageList
    case pageViews
}

/**

 The response contains a JSON object, which always has a Boolean field ok. If ok equals true, the request was successful, and the result of the query can be found in the result field. In case of an unsuccessful request, ok equals false, and the error is explained in the error field (e.g. SHORT_NAME_REQUIRED). All queries must be made using UTF-8.

 */
class Response {
    var type: ResponseType?
    
    var ok: Bool?
    var error: String?

    var account: Account?
    var page: Page?
    var pageList: PageList?
    var pageViews: PageViews?
    
    class func createErrorResponse(error: String) -> Response {
        let res = Response()
        
        res.type = .error
        res.ok = false
        res.error = error
        
        return res
    }
}
