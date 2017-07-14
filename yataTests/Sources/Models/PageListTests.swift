//
//  PageListTests.swift
//  yata
//
//  Created by HS Song on 2017. 6. 15..
//  Copyright © 2017년 HS Song. All rights reserved.
//

import Foundation

import XCTest

class PageListTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testSimple() {
        let jsonObject: [String: Any] = [
            "total_count": 1,
            "pages": [
                [
                    "path": "test-06-09-2",
                    "url": "http://telegra.ph/test-06-09-2",
                    "title": "title is modified",
                    "description": "Pull quote text\nhttp://telegra.ph/test-06-09-2",
                    "author_name": "test",
                    "author_url": "http://apple.com/",
                    "views": 10,
                    "can_edit": true
                ]
            ]
        ]
        
        let jsonString = convertJSONString(from: jsonObject)
        XCTAssertNotNil(jsonString)
      
        let pageList = PageList(JSONString: jsonString!)
        XCTAssertNotNil(pageList)
        
        XCTAssertEqual(pageList?.totalCount, 1)
        XCTAssertEqual(pageList?.pages?[0].authorName, "test")
    }
}
