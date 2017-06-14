//
//  NodeElementTests.swift
//  yata
//
//  Created by HS Song on 2017. 6. 14..
//  Copyright © 2017년 HS Song. All rights reserved.
//

import Foundation

import XCTest

class NodeElementTests: XCTestCase {

    override func setUp() {
        super.setUp()

    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testNoJsonString() {
        let nodeElement = NodeElement(JSONString: "test")
        XCTAssertNil(nodeElement)
    }
    
    func testMappingSimple() {
        let jsonObject: [String: Any] =	[
            "tag": "p",
            "attrs": [
                "id": "Big-text",
                "target": "_blank"
            ],
            "children": [ "This is a test" ]
        ]
        let jsonString = convertJSONString(from: jsonObject)
        XCTAssertNotNil(jsonString)
        
        let nodeElement = NodeElement(JSONString: jsonString!)
        XCTAssertNotNil(nodeElement)
        
        XCTAssertEqual(nodeElement?.tag, "p")
        XCTAssertEqual(nodeElement?.attrs?.id, "Big-text")
        XCTAssertEqual(nodeElement?.children?.count, 1)
        
        if let node = nodeElement?.children?[0] {
            switch node.type {
            case .string:
                XCTAssertEqual(node.value, "This is a test")
            default:
                XCTAssert(false)
            }
        } else {
            XCTAssert(false)
        }
    }
    
    func testMappingComplex() {

        let jsonObject: [String: Any] =	[
            "tag": "figure",
            "attrs": [
                "id": "Big-text"
            ],
            "children": [
                [
                    "tag": "img",
                    "attrs": [
                        "src": "/file/15e6f3a9880edd9ef2436.png",
                        "id": "test"
                    ],
                    "children": [
                        [
                            "tag": "img",
                            "attrs": [
                                "src": "/file/15e6f3a9880edd9ef2436.png",
                                "id": "test"
                            ],
                            "children": [
                                "테스트 이미지"
                            ]
                        ]
                    ]
                ],
                [
                    "tag": "figcaption",
                    "children": [
                        "테스트 이미지"
                    ]
                ]
            ]
        ]
        let jsonString = convertJSONString(from: jsonObject)
        XCTAssertNotNil(jsonString)
        
        let nodeElement = NodeElement(JSONString: jsonString!)
        XCTAssertNotNil(nodeElement)
        
        XCTAssertEqual(nodeElement?.tag, jsonObject["tag"] as? String)
        XCTAssertEqual(nodeElement?.attrs?.id, "Big-text")

        if let children = nodeElement?.children {
            for item in children {
                switch item.element.tag! {
                case "img":
                    XCTAssertEqual(item.element.attrs?.id, "test")
                    if let subChild = item.element.children?[0] {
                        XCTAssertEqual(subChild.element.tag, "img")
                        XCTAssertEqual(subChild.element.attrs?.id, "test")
                        XCTAssertEqual(subChild.element.children?[0].value, "테스트 이미지")
                    } else {
                        XCTAssert(false)
                    }
                case "figcaption":
                    XCTAssertEqual(item.element.children?[0].value, "테스트 이미지")
                default:
                    XCTAssert(false)
                }
            }
        }
    }
}
