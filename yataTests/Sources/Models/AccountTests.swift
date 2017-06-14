//
//  AccountTests.swift
//  yata
//
//  Created by HS Song on 2017. 6. 13..
//  Copyright © 2017년 HS Song. All rights reserved.
//

import XCTest

class AccountTests: XCTestCase {
    
    let jsonObject: [String: Any] = [
        "short_name": "test",
        "author_name": "test authro",
        "author_url": "https://test.com",
        "auth_url": "https://edit.telegra.ph/auth/aadfadlkfj",
        "page_count": 3
    ]
    var jsonString: String?
    
    override func setUp() {
        super.setUp()
        
        if jsonString == nil {
            jsonString = convertJSONString(from: jsonObject)
        }
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testMapping() {
        let account = Account(JSONString: jsonString!)
        XCTAssertNotNil(account)

        XCTAssertEqual(account!.shortName, jsonObject["short_name"] as? String)
        XCTAssertEqual(account!.authorName, jsonObject["author_name"] as? String)
        XCTAssertEqual(account!.authorUrl, jsonObject["author_url"] as? String)
        XCTAssertEqual(account!.authUrl, jsonObject["auth_url"] as? String)
        XCTAssertEqual(account!.pageCount, jsonObject["page_count"] as? Int)
        
    }
}
