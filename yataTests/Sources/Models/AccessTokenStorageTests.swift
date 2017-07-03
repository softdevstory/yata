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

    var accessToken: String?
    
    override func setUp() {
        super.setUp()
        
        accessToken = AccessTokenStorage.loadAccessToken()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        if let accessToken = accessToken {
            
            AccessTokenStorage.saveAccessToken(accessToken)
            self.accessToken = nil
        }
        
        super.tearDown()
    }
    
    func testSimple() {

        AccessTokenStorage.saveAccessToken("token")
        
        let token = AccessTokenStorage.loadAccessToken()
        XCTAssertEqual(token, "token")
        
        AccessTokenStorage.deleteAccessToken()
        
        let deleted = AccessTokenStorage.loadAccessToken()
        XCTAssertNil(deleted)
    }

}
