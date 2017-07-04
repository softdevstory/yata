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

    private let bag = DisposeBag()
    
    private let provider = RxMoyaProvider<TelegraphApi>()

    private func checkError<E>(observer: AnyObserver<E>, value: [String: Any]?) -> Bool {
        guard let value = value else {
            observer.onError(TelegraphError.WrongResponse)
            return false
        }
        
        guard let ok = value["ok"] as? Bool, ok else {
            if let error = value["error"] as? String {
                observer.onError(TelegraphError.ErrorResponse(errorCode: error))
            } else {
                observer.onError(TelegraphError.NoErrorCode)
            }
            return false
        }
        
        guard let _ = value["result"] as? [String: Any] else {
            observer.onError(TelegraphError.NoResult)
            return false
        }
        
        return true
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
                    guard self.checkError(observer: observer, value: value) else {
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
                    guard self.checkError(observer: observer, value: value) else {
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
                    guard self.checkError(observer: observer, value: value) else {
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
                    guard self.checkError(observer: observer, value: value) else {
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
}
