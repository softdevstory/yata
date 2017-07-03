import RxSwift
import Moya
import Foundation

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
        return Data(base64Encoded: "")!
    }
    
    var task: Task {
        return .request
    }
}

let bag = DisposeBag()

let provider = RxMoyaProvider<TelegraphApi>()

func test() -> Observable<Void> {
    print("1")
    
    return Observable<Void>.create { observer in
    
        print("2")
        
        let param = GetAccountInfoParameter(accessToken: "b968da509bb76866c35425099bc0989a5ec3b32997d55286c657e6994bbb1")
        
        let disposable = provider.request(.getAccountInfo(parameter: param))
            .filterSuccessfulStatusCodes()
            .mapJSON()
            .map { data -> [String: Any]? in
                print("3")
                return data as? [String: Any]
            }
//            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { value in
                print("adjfklasdjf")
                print(value)

                observer.onCompleted()
            }, onError: { error in
                observer.onError(error)
            })

        return Disposables.create {
            disposable.dispose()
        }
    }
}

let a = test()

a.subscribe(onNext: { value in
    print("next")
}, onError: { error in
    print(error.localizedDescription)
}, onCompleted: {
    print("complete")
})

sleep(5)
