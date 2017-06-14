//
//  AttrsTests.swift
//  yata
//
//  Created by HS Song on 2017. 6. 13..
//  Copyright © 2017년 HS Song. All rights reserved.
//

import XCTest

class AttrsTests: XCTestCase {
    
    let jsonObject: [String: Any] = [
        "href": "http://apple.com/",
        "target": "_blank",
        "id": "Big-text",
        "src": "/file/15e6f3a9880edd9ef2436.png"
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
        let attrs = Attrs(JSONString: jsonString!)
        XCTAssertNotNil(attrs)

        XCTAssertEqual(attrs?.href, jsonObject["href"] as? String)
        XCTAssertEqual(attrs?.target, jsonObject["target"] as? String)
        XCTAssertEqual(attrs?.id, jsonObject["id"] as? String)
        XCTAssertEqual(attrs?.src, jsonObject["src"] as? String)
    }
}
