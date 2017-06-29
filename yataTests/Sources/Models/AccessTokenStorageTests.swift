//
//  AccessTokenStorageTests.swift
//  yata
//
//  Created by HS Song on 2017. 6. 29..
//  Copyright © 2017년 HS Song. All rights reserved.
//

import Foundation

import XCTest

class AccessTokenStorageTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSimple() {
        let ats = AccessTokenStorage()
        
        ats.saveAccessToken("token")
        
        let token = ats.loadAccessToken()
        XCTAssertEqual(token, "token")
        
        ats.deleteAccessToken()
        
        let deleted = ats.loadAccessToken()
        XCTAssertNil(deleted)
    }

}
