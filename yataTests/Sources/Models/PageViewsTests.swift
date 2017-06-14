//
//  PageViewsTests.swift
//  yata
//
//  Created by HS Song on 2017. 6. 13..
//  Copyright © 2017년 HS Song. All rights reserved.
//


import XCTest

class PageViewsTests: XCTestCase {
    
    let jsonObject: [String: Any] = [
        "views": 123
    ]
    var jsonString: String?
    
    override func setUp() {
        super.setUp()
        
        if jsonString == nil {
            let jsonData: NSData

            do {
                jsonData = try JSONSerialization.data(withJSONObject: jsonObject, options: JSONSerialization.WritingOptions()) as Data as NSData
                jsonString = String(data: jsonData as Data, encoding: String.Encoding.utf8)
            } catch _ {
                print ("JSON Failure")
            }
        }
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testMapping() {
        let pageViews = PageViews(JSONString: jsonString!)
        XCTAssertNotNil(pageViews)

        XCTAssertEqual(pageViews!.views, jsonObject["views"] as? Int)
    }
}
