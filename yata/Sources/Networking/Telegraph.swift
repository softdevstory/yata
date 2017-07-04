//
//  Telegraph.swift
//  yata
//
//  Created by HS Song on 2017. 7. 3..
//  Copyright © 2017년 HS Song. All rights reserved.
//

import Foundation

import RxSwift
import Moya

enum TelegraphError: Swift.Error {
    case WrongResponse
    case NoErrorCode
    case NoResult
    case WrongResultFormat
    case ErrorResponse(errorCode: String)
}

class Telegraph {

    static let shared = Telegraph()
    
    private let bag = DisposeBag()
    
    private let provider = RxMoyaProvider<TelegraphApi>()

    private func checkError(value: [String: Any]?) -> TelegraphError? {
        guard let value = value else {
            return TelegraphError.WrongResponse
        }
        
        guard let ok = value["ok"] as? Bool, ok else {
            if let error = value["error"] as? String {
                return TelegraphError.ErrorResponse(errorCode: error)
            } else {
                return TelegraphError.NoErrorCode
            }
        }
        
        guard let _ = value["result"] as? [String: Any] else {
            return TelegraphError.NoResult
        }
        
        return nil
    }
    
    func createAccount(shortName: String, authorName: String?, authorUrl: String?) -> Observable<Account> {
        let observable = Observable<Account>.create { observer in
            
            let param = CreateAccountParameter(shortName: shortName, authorName: authorName, authorUrl: authorUrl)
            
            let disposable = self.provider.request(.createAccount(parameter: param))
                .filterSuccessfulStatusCodes()
                .mapJSON()
                .map { data -> [String: Any]? in
                    return data as? [String: Any]
                }
                .subscribe(onNext: { value in
                    if let error = self.checkError(value: value) {
                        observer.onError(error)
                        return
                    }

                    let result = value?["result"] as! [String: Any]
                    
                    guard let account = Account(JSON: result) else {
                        observer.onError(TelegraphError.WrongResultFormat)
                        return
                    }
                    
                    observer.onNext(account)
                    observer.onCompleted()
                    
                }, onError: { error in
                    observer.onError(error)
                })
            
            return Disposables.create {
                disposable.dispose()
            }
        }
        
        return observable
    }

    func getAccountInfo(accessToken: String) -> Observable<Account> {
        let observable = Observable<Account>.create { observer in

            let param = GetAccountInfoParameter(accessToken: accessToken)

            let disposable = self.provider.request(.getAccountInfo(parameter: param))
                .filterSuccessfulStatusCodes()
                .mapJSON()
                .map { data -> [String: Any]? in
                    return data as? [String: Any]
                }
                .subscribe(onNext: { value in
                    if let error = self.checkError(value: value) {
                        observer.onError(error)
                        return
                    }
                    
                    let result = value?["result"] as! [String: Any]
                    
                    guard let account = Account(JSON: result) else {
                        observer.onError(TelegraphError.WrongResultFormat)
                        return
                    }
                    
                    observer.onNext(account)
                    observer.onCompleted()
                        
                }, onError: { error in
                    observer.onError(error)
                })

            return Disposables.create {
                disposable.dispose()
            }
        }
        
        return observable
    }
    
    func editAccountInfo(accessToken: String, shortName: String, authorName: String?, authorUrl: String?) -> Observable<Account> {
    
        let observable = Observable<Account>.create { observer in
        
            let param = EditAccountInfoParameter(accessToken: accessToken, shortName: shortName, authorName: authorName, authorUrl: authorUrl)

            let disposable = self.provider.request(.editAccountInfo(parameter: param))
                .filterSuccessfulStatusCodes()
                .mapJSON()
                .map { data -> [String: Any]? in
                    return data as? [String: Any]
                }
                .subscribe(onNext: { value in
                    if let error = self.checkError(value: value) {
                        observer.onError(error)
                        return
                    }

                    let result = value?["result"] as! [String: Any]
                    
                    guard let account = Account(JSON: result) else {
                        observer.onError(TelegraphError.WrongResultFormat)
                        return
                    }
                    
                    observer.onNext(account)
                    observer.onCompleted()
                        
                }, onError: { error in
                    observer.onError(error)
                })

            return Disposables.create {
                disposable.dispose()
            }
        }
    
        return observable
    }
    
    func revokeAccessToken(accessToken: String) -> Observable<Account> {
        let observable = Observable<Account>.create { observer in
            let param = RevokeAccessTokenParameter(accessToken: accessToken)
            
            let disposable = self.provider.request(.revokeAccessToken(parameter: param))
                .filterSuccessfulStatusCodes()
                .mapJSON()
                .map { data -> [String: Any]? in
                    return data as? [String: Any]
                }
                .subscribe(onNext: { value in
                    if let error = self.checkError(value: value) {
                        observer.onError(error)
                        return
                    }
                    
                    let result = value?["result"] as! [String: Any]

                    guard let account = Account(JSON: result) else {
                        observer.onError(TelegraphError.WrongResultFormat)
                        return
                    }
                    
                    observer.onNext(account)
                    observer.onCompleted()
                    
                }, onError: { error in
                    observer.onError(error)
                })
            

            return Disposables.create {
                disposable.dispose()
            }
        }
        
        return observable
    }
    
    func getPageList(accessToken: String, offset: Int = 0, limit: Int = 50) -> Observable<PageList> {
        let observable = Observable<PageList>.create { observer in

            let param = GetPageListParameter(accessToken: accessToken, offset: offset, limit: limit)
        
            let disposable = self.provider.request(.getPageList(parameter: param))
                .filterSuccessfulStatusCodes()
                .mapJSON()
                .map { data in
                    return data as? [String: Any]
                }
                .filter { $0 != nil }
                .subscribe(onNext: { value in
                    if let error = self.checkError(value: value) {
                        observer.onError(error)
                        return
                    }
                    
                    let result = value?["result"] as! [String: Any]

                    guard let pageList = PageList(JSON: result) else {
                        observer.onError(TelegraphError.WrongResultFormat)
                        return
                    }

                    observer.onNext(pageList)
                    observer.onCompleted()
                    
                }, onError: { error in
                    observer.onError(error)
                })

            return Disposables.create {
                disposable.dispose()
            }
        }
        
        return observable
    }
    
    func getPage(path: String) -> Observable<Page> {
        let observable = Observable<Page>.create { observer in

            let param = GetPageParameter(path: path, returnContent: true)
        
            let disposable = self.provider.request(.getPage(parameter: param))
                .filterSuccessfulStatusCodes()
                .mapJSON()
                .map { data in
                    return data as? [String: Any]
                }
                .filter { $0 != nil }
                .subscribe(onNext: { value in
                    if let error = self.checkError(value: value) {
                        observer.onError(error)
                        return
                    }
                    
                    let result = value?["result"] as! [String: Any]

                    guard let page = Page(JSON: result) else {
                        observer.onError(TelegraphError.WrongResultFormat)
                        return
                    }

                    observer.onNext(page)
                    observer.onCompleted()
                    
                }, onError: { error in
                    observer.onError(error)
                })

            return Disposables.create {
                disposable.dispose()
            }
        }
        
        return observable
    }
}
