//
//  AccountPaneViewModel.swift
//  yata
//
//  Created by HS Song on 2017. 6. 30..
//  Copyright © 2017년 HS Song. All rights reserved.
//

import Foundation

import RxSwift

class AccountPaneViewModel {
    
    private let telegraph = Telegraph.shared

    var shortName = Variable<String>("")
    var authorName = Variable<String?>(nil)
    var authorUrl = Variable<String?>(nil)
    
    func getAccountInfo() -> Observable<Void> {
    
        let observable = Observable<Void>.create { observer in
            guard let accessToken = AccessTokenStorage.loadAccessToken() else {
                observer.onError(YataError.NoAccessToken)
                return Disposables.create()
            }
            
            let disposable = self.telegraph.getAccountInfo(accessToken: accessToken)
                .observeOn(MainScheduler.instance)
                .subscribe(onNext: { account in
                    self.shortName.value = account.shortName!
                    self.authorName.value = account.authorName
                    self.authorUrl.value = account.authorUrl
                    
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
    
    func editAccountInfo(shortName: String, authorName: String?, authorUrl: String?) -> Observable<Void> {
        let observable = Observable<Void>.create { observer in
            guard let accessToken = AccessTokenStorage.loadAccessToken() else {
                observer.onError(YataError.NoAccessToken)
                return Disposables.create()
            }
            
            let disposable = self.telegraph.editAccountInfo(accessToken: accessToken, shortName: shortName, authorName: authorName, authorUrl: authorUrl)
                .observeOn(MainScheduler.instance)
                .subscribe(onNext: { account in
                    self.shortName.value = account.shortName!
                    self.authorName.value = account.authorName
                    self.authorUrl.value = account.authorUrl
                    
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
    
    func revokeAccessToken() -> Observable<Void> {
        let observable = Observable<Void>.create { observer in
            guard let accessToken = AccessTokenStorage.loadAccessToken() else {
                observer.onError(YataError.NoAccessToken)
                return Disposables.create()
            }

            let disposable = self.telegraph.revokeAccessToken(accessToken: accessToken)
                .observeOn(MainScheduler.instance)
                .subscribe(onNext: { account in
                
                    AccessTokenStorage.saveAccessToken(account.accessToken!)

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
