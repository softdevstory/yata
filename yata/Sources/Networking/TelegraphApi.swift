//
//  TelegraphApi.swift
//  yata
//
//  Created by HS Song on 2017. 6. 15..
//  Copyright © 2017년 HS Song. All rights reserved.
//

import Moya

// MARK: parameter structure

struct CreateAccountParameter {
    let shortName: String
    let authorName: String?
    let authorUrl: String?
    
    func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [:]
        dict["short_name"] = shortName
        if let authorName = authorName {
            dict["author_name"] = authorName
        }
        if let authorUrl = authorUrl {
            dict["author_url"] = authorUrl
        }
        
        return dict
    }
}

struct CreatePageParameter {
    let accessToken: String
    let title: String
    let authorName: String?
    let authorUrl: String?
    let content: String
    let returnContent: Bool?
    
    func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [:]
        
        dict["access_token"] = accessToken
        dict["title"] = title
        dict["content"] = content

        if let authorName = authorName {
            dict["author_name"] = authorName
        }
        if let authorUrl = authorUrl {
            dict["author_url"] = authorUrl
        }
        if let returnContent = returnContent {
            dict["return_content"] = returnContent
        }
        
        return dict
    }
}

struct EditAccountInfoParameter {
    let accessToken: String
    let shortName: String?
    let authorName: String?
    let authorUrl: String?
    
    func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [:]
        
        dict["access_token"] = accessToken
        
        if let shortName = shortName {
            dict["short_name"] = shortName
        }
        if let authorName = authorName {
            dict["author_name"] = authorName
        }
        if let authorUrl = authorUrl {
            dict["author_url"] = authorUrl
        }
        
        return dict
    }
}

struct EditPageParameter {
    let path: String // path is part of URL
    
    let accessToken: String
    let title: String
    let authorName: String?
    let authorUrl: String?
    let content: String
    let returnContent: Bool?
    
    func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [:]
        
        dict["access_token"] = accessToken
        dict["title"] = title
        dict["content"] = content

        if let authorName = authorName {
            dict["author_name"] = authorName
        }
        if let authorUrl = authorUrl {
            dict["author_url"] = authorUrl
        }
        if let returnContent = returnContent {
            dict["return_content"] = returnContent
        }
        
        return dict
    }
}

struct GetAccountInfoParameter {
    let accessToken: String
    
    func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [:]

        dict["access_token"] = accessToken
        
        // request all fields
        dict["fields"] = "[\"short_name\", \"author_name\", \"author_url\", \"auth_url\", \"page_count\"]"
        
        return dict
    }
}

struct GetPageParameter {
    let path: String // path is part of URL
    
    let returnContent: Bool?
    
    func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [:]
        
        if let returnContent = returnContent {
            dict["return_content"] = returnContent
        }
        
        return dict
    }
}

struct GetPageListParameter {
    let accessToken: String
    let offset: Int?
    let limit: Int?
    
    func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [:]
        
        dict["access_token"] = accessToken
        if let offset = offset {
            dict["offset"] = offset
        }
        if let limit = limit {
            dict["limit"] = limit
        }
        return dict
    }
}

struct GetViewsParameter {
    let path: String // path is part of URL

    /* TODO: not implemented.
     year (Integer, 2000-2100)
     Required if month is passed. If passed, the number of page views for the requested year will be returned.
     month (Integer, 1-12)
     Required if day is passed. If passed, the number of page views for the requested month will be returned.
     day (Integer, 1-31)
     Required if hour is passed. If passed, the number of page views for the requested day will be returned.
     hour (Integer, 0-24)
     */
    
     func toDictionary() -> [String: Any] {
        return [:]
     }
}

// MARK: Telegra.ph API

enum TelegraphApi {

    /// Use this method to create a new Telegraph account. Most users only need one account, but this can be useful for channel administrators who would like to keep individual author names and profile links for each of their channels. On success, returns an Account object with the regular fields and an additional access_token field.
    case createAccount(parameter: CreateAccountParameter)
    
    /// Use this method to create a new Telegraph page. On success, returns a Page object.
    case createPage(parameter: CreatePageParameter)
    
    /// Use this method to update information about a Telegraph account. Pass only the parameters that you want to edit. On success, returns an Account object with the default fields.
    case editAccountInfo(paramter: EditAccountInfoParameter)
    
    /// Use this method to edit an existing Telegraph page. On success, returns a Page object.
    case editPage(parameter: EditPageParameter)
    
    /// Use this method to get information about a Telegraph account. Returns an Account object on success.
    case getAccountInfo(parameter: GetAccountInfoParameter)
    
    /// Use this method to get a Telegraph page. Returns a Page object on success.
    case getPage(parameter: GetPageParameter)
    
    /// Use this method to get a list of pages belonging to a Telegraph account. Returns a PageList object, sorted by most recently created pages first.
    case getPageList(parameter: GetPageListParameter)
    
    /// Use this method to get the number of views for a Telegraph article. Returns a PageViews object on success. By default, the total number of page views will be returned.
    case getViews(parameter: GetViewsParameter)
    
    /// Use this method to revoke access_token and generate a new one, for example, if the user would like to reset all connected sessions, or you have reasons to believe the token was compromised. On success, returns an Account object with new access_token and auth_url fields.
    case revokeAccessToken
}

extension TelegraphApi: TargetType {
    var baseURL: URL {
        return URL(string: "https://api.telegra.ph")!
    }
    
    var path: String {
        switch self {
        case .createAccount:
            return "/createAccount"
        case .createPage:
            return "/createPage"
        case .editAccountInfo:
            return "/editAccountInfo"
        case .editPage(let parameter):
            return "/editPage/\(parameter.path)"
        case .getAccountInfo:
            return "/getAccountInfo"
        case .getPage(let parameter):
            return "/getPage/\(parameter.path)"
        case .getPageList:
            return "/getPageList"
        case .getViews(let parameter):
            return "/getViews/\(parameter.path)"
        case .revokeAccessToken:
            return "/revokeAccessToken"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .createAccount, .createPage, .editAccountInfo, .editPage, .revokeAccessToken:
            return .post
        case .getAccountInfo, .getPage, .getPageList, .getViews:
            return .get
        }
    }
    
    var parameters: [String : Any]? {
        var param: [String: Any]! = nil
        
        switch self {
        case .createAccount(let parameter):
            param = parameter.toDictionary()
        case .createPage(let parameter):
            param = parameter.toDictionary()
        case .editAccountInfo(let parameter):
            param = parameter.toDictionary()
        case .editPage(let parameter):
            param = parameter.toDictionary()
        case .getAccountInfo(let parameter):
            param = parameter.toDictionary()
        case .getPage(let parameter):
            param = parameter.toDictionary()
        case .getPageList(let parameter):
            param = parameter.toDictionary()
        case .getViews(let parameter):
            param = parameter.toDictionary()
            
        case .revokeAccessToken:
            break
        }
        
        return param
    }
    
    var parameterEncoding: ParameterEncoding {
        switch self {
        case .createAccount, .createPage, .editAccountInfo, .editPage, .revokeAccessToken:
            return JSONEncoding.default

        case .getAccountInfo, .getPage, .getPageList, .getViews:
            return URLEncoding.queryString
        }
    }
    
    var sampleData: Data {
        switch self {
        case .createAccount:
            return "{\"ok\":true,\"result\":{\"short_name\":\"Sandbox\",\"author_name\":\"Anonymous\",\"author_url\":\"\",\"access_token\":\"ccc8a24ec410bcc09d24307cc5681049dc9d4c18d089006234499df7a34c\",\"auth_url\":\"https://edit.telegra.ph/auth/MBcuWpLmHB91mBe1xAIE8ydJFG1ULNhxor2lOLFwlM\"}}".utf8Encoded

        case .createPage:
            return "{\"ok\":true,\"result\":{\"path\":\"Sample-Page-06-15\",\"url\":\"http://telegra.ph/Sample-Page-06-15\",\"title\":\"Sample Page\",\"description\":\"\",\"author_name\":\"Anonymous\",\"content\":[{\"tag\":\"p\",\"children\":[\"Hello, world!\"]}],\"views\":0,\"can_edit\":true}}".utf8Encoded

        case .editAccountInfo:
            return "{\"ok\":true,\"result\":{\"short_name\":\"Sandbox\",\"author_name\":\"Anonymous\",\"author_url\":\"http://telegra.ph/api\"}}".utf8Encoded

        case .editPage:
            return "{\"ok\":true,\"result\":{\"path\":\"Sample-Page-12-15\",\"url\":\"http://telegra.ph/Sample-Page-12-15\",\"title\":\"Sample Page\",\"description\":\"Hello, world!\",\"author_name\":\"Anonymous\",\"content\":[{\"tag\":\"p\",\"children\":[\"Hello, world!\"]}],\"views\":248,\"can_edit\":true}}".utf8Encoded
            
        case .getAccountInfo:
            return "{\"ok\":true,\"result\":{\"short_name\":\"Sandbox\",\"page_count\":5834}}".utf8Encoded
            
        case .getPage:
            return "{\"ok\":true,\"result\":{\"path\":\"Sample-Page-12-15\",\"url\":\"http://telegra.ph/Sample-Page-12-15\",\"title\":\"Sample Page\",\"description\":\"Hello, world!\",\"author_name\":\"Anonymous\",\"content\":[{\"tag\":\"p\",\"children\":[\"Hello, world!\"]}],\"views\":248}}".utf8Encoded
            
        case .getPageList:
            return "{\"ok\": true,\"result\": {\"total_count\": 1,\"pages\": [{\"path\": \"test-06-09-2\",\"url\": \"http://telegra.ph/test-06-09-2\", \"title\": \"title is modified\",\"description\":\"double quote text\nhttp://telegra.ph/test-06-09-2\",\"author_name\": \"test\",\"author_url\": \"http://apple.com/\",\"views\": 10,\"can_edit\": true}]}}".utf8Encoded
        
        case .getViews:
            return "{\"ok\":true,\"result\":{\"views\":40}}".utf8Encoded
            
        case .revokeAccessToken:
            return "{\"ok\": true,\"result\": {\"access_token\": \"cd65282693196adfca2dfc549691cc673fca667c9faa1bff377bd57bfdf0\",\"auth_url\": \"https://edit.telegra.ph/auth/JC824iTLGZxq2lrtz1l1PbTjZUcRoUa7ug8xz1idZN\"}}".utf8Encoded
        }
    }
    
    var task: Task {
        return .request
    }
}
