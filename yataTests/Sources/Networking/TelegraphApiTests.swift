//
//  TelegraphApiTests.swift
//  yata
//
//  Created by HS Song on 2017. 6. 15..
//  Copyright © 2017년 HS Song. All rights reserved.
//

import XCTest
import RxTest
import RxBlocking
import RxSwift
import Moya

class TelegraphApiTest: XCTestCase {
    
    let bag = DisposeBag()
    
    let provider = RxMoyaProvider<TelegraphApi>()

    override func setUp() {
        super.setUp()

    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func url(route: TelegraphApi) -> String {
        return route.baseURL.appendingPathComponent(route.path).absoluteString
    }
    
    func testCreateAccount() {
        do {
            let param = CreateAccountParameter(shortName: "Sandbox", authorName: "Anonymous", authorUrl: nil)
            let response = try provider.request(.createAccount(parameter: param))
                .toBlocking().first()
            XCTAssertNotNil(response)

            let json = try response?.mapJSON() as? [String: Any]
            XCTAssertNotNil(json)
            
            XCTAssertEqual(json?["ok"] as? Bool, true)
            
            let result = json?["result"] as? [String: Any]
            XCTAssertNotNil(result)
            
            let account = Account(JSON: result!)
            XCTAssertNotNil(account)
            
            XCTAssertEqual(account?.shortName, "Sandbox")
            XCTAssertEqual(account?.authorName, "Anonymous")
            
        } catch {
            XCTAssert(false)
        }
    }
    
    func testRevokeAccessToken() {
        do {
            let param = RevokeAccessTokenParameter(accessToken: "b968da509bb76866c35425099bc0989a5ec3b32997d55286c657e6994bbb")
            let response = try provider.request(.revokeAccessToken(parameter: param))
                .toBlocking().first()
            XCTAssertNotNil(response)

            let json = try response?.mapJSON() as? [String: Any]
            XCTAssertNotNil(json)
            
            XCTAssertEqual(json?["ok"] as? Bool, false)
            
            let error = json?["error"] as? String
            XCTAssertNotNil(error)
            
            XCTAssertEqual(error, "SANDBOX_TOKEN_REVOKE_DENIED")
            
        } catch {
            XCTAssert(false)
        }
    }
    
    func testCreatePage() {
        do {
            let param = CreatePageParameter(
                accessToken: "b968da509bb76866c35425099bc0989a5ec3b32997d55286c657e6994bbb",
                title: "Sample Page",
                authorName: "Anonymous",
                authorUrl: nil,
                content: "[{\"tag\":\"p\",\"children\":[\"Hello, world!\"]}]",
                returnContent: true)
            
            let response = try provider.request(.createPage(parameter: param))
                .toBlocking().first()
            XCTAssertNotNil(response)
            
            let json = try response?.mapJSON() as? [String: Any]
            XCTAssertNotNil(json)

            XCTAssertEqual(json?["ok"] as? Bool, true)
            
            let result = json?["result"] as? [String: Any]
            XCTAssertNotNil(result)

            let page = Page(JSON: result!)
            XCTAssertNotNil(page)
            
            XCTAssertEqual(page?.title, "Sample Page")
            XCTAssertEqual(page?.authorName, "Anonymous")
            
            XCTAssertEqual(page?.content?.count, 1)
            XCTAssertEqual(page?.content?[0].element.tag, "p")
            XCTAssertEqual(page?.content?[0].element.children?.count, 1)
            XCTAssertEqual(page?.content?[0].element.children?[0].value, "Hello, world!")

        } catch {
            XCTAssert(false)
        }
    }
    
    func testEditAccountInfo() {
        do {
            let param = EditAccountInfoParameter(
                accessToken: "b968da509bb76866c35425099bc0989a5ec3b32997d55286c657e6994bbb",
                shortName: "Sandbox",
                authorName: "Anonymous",
                authorUrl: "https://telegra.ph/")
            
            let response = try provider.request(.editAccountInfo(parameter: param))
                .toBlocking().first()
            XCTAssertNotNil(response)
            
            let json = try response?.mapJSON() as? [String: Any]
            XCTAssertNotNil(json)

            XCTAssertEqual(json?["ok"] as? Bool, true)
            
            let result = json?["result"] as? [String: Any]
            XCTAssertNotNil(result)
            
            let account = Account(JSON: result!)
            XCTAssertNotNil(account)
            
            XCTAssertEqual(account?.shortName, "Sandbox")
            XCTAssertEqual(account?.authorName, "Anonymous")
            XCTAssertEqual(account?.authorUrl, "https://telegra.ph/")
        } catch {
            XCTAssert(false)
        }
    }
    
    func testEditPage() {
        do {
            let param = EditPageParameter(
                path: "Sample-Page-12-15",
                accessToken: "b968da509bb76866c35425099bc0989a5ec3b32997d55286c657e6994bbb",
                title: "Sample Page",
                authorName: "Anonymous",
                authorUrl: nil,
                content: "[{\"tag\":\"p\",\"children\":[\"Hello, world!\"]}]",
                returnContent: true)
            
            let response = try provider.request(.editPage(parameter: param))
                .toBlocking().first()
            XCTAssertNotNil(response)
            
            let json = try response?.mapJSON() as? [String: Any]
            XCTAssertNotNil(json)

            XCTAssertEqual(json?["ok"] as? Bool, true)
            
            let result = json?["result"] as? [String: Any]
            XCTAssertNotNil(result)

            let page = Page(JSON: result!)
            XCTAssertNotNil(page)
            
            XCTAssertEqual(page?.title, "Sample Page")
            XCTAssertEqual(page?.authorName, "Anonymous")
            
            XCTAssertEqual(page?.content?.count, 1)
            XCTAssertEqual(page?.content?[0].element.tag, "p")
            XCTAssertEqual(page?.content?[0].element.children?.count, 1)
            XCTAssertEqual(page?.content?[0].element.children?[0].value, "Hello, world!")

        } catch {
            XCTAssert(false)
        }
    }
    
    func testGetAccountInfo() {
        do {
            let param = GetAccountInfoParameter(accessToken: "b968da509bb76866c35425099bc0989a5ec3b32997d55286c657e6994bbb")
            
            let response = try provider.request(.getAccountInfo(parameter: param))
                .toBlocking().first()
            XCTAssertNotNil(response)
            
            let json = try response?.mapJSON() as? [String: Any]
            XCTAssertNotNil(json)

            XCTAssertEqual(json?["ok"] as? Bool, true)
            
            let result = json?["result"] as? [String: Any]
            XCTAssertNotNil(result)

            let account = Account(JSON: result!)
            XCTAssertNotNil(account)
            
            XCTAssertEqual(account?.shortName, "Sandbox")
            XCTAssertEqual(account?.authorName, "Anonymous")
        } catch {
            XCTAssert(false)
        }
    }
    
    func testGetPage() {
        do {
            let param = GetPageParameter(path: "Sample-Page-12-15", returnContent: true)
            
            let response = try provider.request(.getPage(parameter: param))
                .toBlocking().first()
            XCTAssertNotNil(response)
            
            let json = try response?.mapJSON() as? [String: Any]
            XCTAssertNotNil(json)

            XCTAssertEqual(json?["ok"] as? Bool, true)
            
            let result = json?["result"] as? [String: Any]
            XCTAssertNotNil(result)

            let page = Page(JSON: result!)
            XCTAssertNotNil(page)
            
            XCTAssertEqual(page?.title, "Sample Page")
            XCTAssertEqual(page?.authorName, "Anonymous")
            
            XCTAssertEqual(page?.content?.count, 1)
            XCTAssertEqual(page?.content?[0].element.tag, "p")
            XCTAssertEqual(page?.content?[0].element.children?.count, 1)
            XCTAssertEqual(page?.content?[0].element.children?[0].value, "Hello, world!")
        } catch {
            XCTAssert(false)
        }
    }
    
    func testGetPageList() {
        do {
            let param = GetPageListParameter(
                accessToken: "b968da509bb76866c35425099bc0989a5ec3b32997d55286c657e6994bbb",
                offset: nil,
                limit: 3)
            
            let response = try provider.request(.getPageList(parameter: param))
                .toBlocking().first()
            XCTAssertNotNil(response)
            
            let json = try response?.mapJSON() as? [String: Any]
            XCTAssertNotNil(json)

            XCTAssertEqual(json?["ok"] as? Bool, true)
            
            let result = json?["result"] as? [String: Any]
            XCTAssertNotNil(result)
            
            let pageList = PageList(JSON: result!)
            XCTAssertNotNil(pageList)
            
            XCTAssertEqual(pageList?.pages?.count, 3)
            
        } catch {
            XCTAssert(false)
        }
    }

    func testGetViews() {
        do {
            let param = GetViewsParameter(path: "Sample-Page-12-15")
            let response = try provider.request(.getViews(parameter: param))
                .toBlocking().first()
            XCTAssertNotNil(response)
            
            let json = try response?.mapJSON() as? [String: Any]
            XCTAssertNotNil(json)
            
            XCTAssertEqual(json?["ok"] as? Bool, true)
            
            let result = json?["result"] as? [String: Any]
            XCTAssertNotNil(result)
            
            XCTAssertNotNil(result?["views"])
            
        } catch {
            XCTAssert(false)
        }
    }
}
