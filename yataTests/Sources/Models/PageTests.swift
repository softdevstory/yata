//
//  PageTests.swift
//  yata
//
//  Created by HS Song on 2017. 6. 14..
//  Copyright © 2017년 HS Song. All rights reserved.
//

import Foundation

import XCTest

class PageTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testSimple() {
        let jsonObject: [String: Any] = [
            "path": "test-06-09-2",
            "url": "http://telegra.ph/test-06-09-2",
            "title": "title is modified",
            "description": "double quote text\nhttp://telegra.ph/test-06-09-2",
            "author_name": "test",
            "author_url": "http://apple.com/",
            "views": 10,
            "can_edit": true
        ]
        
        let jsonString = convertJSONString(from: jsonObject)
        XCTAssertNotNil(jsonString)
        
        let page = Page(JSONString: jsonString!)
        XCTAssertNotNil(page)
        
        XCTAssertEqual(page?.path, jsonObject["path"] as? String)
        XCTAssertEqual(page?.url, jsonObject["url"] as? String)
        XCTAssertEqual(page?.title, jsonObject["title"] as? String)
        XCTAssertEqual(page?.description, jsonObject["description"] as? String)
        XCTAssertEqual(page?.authorName, jsonObject["author_name"] as? String)
        XCTAssertEqual(page?.authorUrl, jsonObject["author_url"] as? String)
        XCTAssertEqual(page?.views, jsonObject["views"] as? Int)
        XCTAssertEqual(page?.canEdit, jsonObject["can_edit"] as? Bool)
    }
    
    func testComplex() {
        let jsonObject: [String: Any] = [
            "path": "test-06-09-2",
            "url": "http://telegra.ph/test-06-09-2",
            "title": "title is modified",
            "description": "double quote text\nhttp://telegra.ph/test-06-09-2",
            "author_name": "test",
            "author_url": "http://apple.com/",
            "content": [
                [
                    "tag": "h3",
                    "attrs": [
                        "id": "This-is-title&#33;"
                    ],
                    "children": [
                        "This is title!"
                    ]
                ],
                [
                    "tag": "p",
                    "children": [
                        "This is a paragraph"
                    ]
                ],
                [
                    "tag": "p",
                    "children": [
                        [
                            "tag": "strong",
                            "children": [
                                "Bold text"
                            ]
                        ]
                    ]
                ],
                [
                    "tag": "p",
                    "children": [
                        [
                            "tag": "em",
                            "children": [
                                "italic text"
                            ]
                        ]
                    ]
                ],
                [
                    "tag": "p",
                    "children": [
                        [
						"tag": "a",
						"attrs": [
							"href": "http://apple.com/",
							"target": "_blank"
                            ],
						"children": [
							"link text"
                            ]
                        ]
                    ]
                ],
                [
                    "tag": "h3",
                    "attrs": [
                        "id": "Big-text"
                    ],
                    "children": [
                        "Big text"
                    ]
                ],
                [
                    "tag": "h4",
                    "attrs": [
                        "id": "little-big-text"
                    ],
                    "children": [
                        "little big text"
                    ]
                ],
                [
                    "tag": "blockquote",
                    "children": [
                        "single quote text"
                    ]
                ],
                [
                    "tag": "aside",
                    "children": [
                        "double quote text"
                    ]
                ],
                [
                    "tag": "p",
                    "children": [
                        [
                            "tag": "a",
                            "attrs": [
							"href": "/test-06-09-2"
                            ],
						"children": [
							"http://telegra.ph/test-06-09-2"
                            ]
                        ]
                    ]
                ],
                [
                    "tag": "p",
                    "children": [
                        [
                            "tag": "br"
                        ]
                    ]
                ],
                [
                    "tag": "figure",
                    "children": [
                        [
                            "tag": "img",
                            "attrs": [
                                "src": "/file/15e6f3a9880edd9ef2436.png"
                            ]
                        ],
                        [
                            "tag": "figcaption",
                            "children": [
                                "테스트 이미지"
                            ]
                        ]
                    ]
                ],
                [
                    "tag": "p",
                    "children": [
                        [
                            "tag": "br"
                        ]
                    ]
                ],
                [
                    "tag": "p",
                    "children": [
                        [
                            "tag": "br"
                        ]
                    ]
                ]
            ],
            "views": 10
        ]
        
        let jsonString = convertJSONString(from: jsonObject)
        XCTAssertNotNil(jsonString)
        
        let page = Page(JSONString: jsonString!)
        XCTAssertNotNil(page)

        XCTAssertEqual(page?.content?.count, 14)
        XCTAssertEqual(page?.content?[11].element.tag, "figure")
        XCTAssertEqual(page?.content?[11].element.children?[0].element.tag, "img")
    }
}
