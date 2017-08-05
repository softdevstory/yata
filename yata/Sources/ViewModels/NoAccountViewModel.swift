//
//  NoAccountViewModel.swift
//  yata
//
//  Created by HS Song on 2017. 8. 5..
//  Copyright © 2017년 HS Song. All rights reserved.
//

import Foundation
import RxSwift

class NoAccountViewModel {
   private let telegraph = Telegraph.shared

    func createAccount(shortName: String, authorName: String?, authorUrl: String?) -> Observable<Void> {
    
        let observable = Observable<Void>.create { observer in
        
            let disposable = self.telegraph.createAccount(shortName: shortName, authorName: authorName, authorUrl: authorUrl)
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
