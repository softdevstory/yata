//
//  PageEditViewModel.swift
//  yata
//
//  Created by HS Song on 2017. 7. 12..
//  Copyright © 2017년 HS Song. All rights reserved.
//

import Foundation

import RxSwift

enum PageEditMode {
    case new
    case edit
}

class PageEditViewModel {

    private let telegraph = Telegraph.shared

    private let bag = DisposeBag()
    
    private var mode = PageEditMode.new
    
    var page = Variable<Page?>(nil)

    func reset(page: Page?) {
        if let page = page {
            mode = .edit
            self.page.value = page
        } else {
            mode = .new
        }
    }
    
    func publisNewPage(title: String, authorName: String, content: String) -> Observable<Void> {
        let observable = Observable<Void>.create { observer in
        
//            guard let accessToken = AccessTokenStorage.loadAccessToken() else {
//                observer.onError(YataError.NoAccessToken)
//                return Disposables.create()
//            }

            // TODO: this is for test
            let accessToken = "b968da509bb76866c35425099bc0989a5ec3b32997d55286c657e6994bbb"

//            let content = "[{ \"tag\": \"h3\", \"children\": [\"This is title!\"]}, { \"tag\": \"p\", \"children\": [\"This is a paragraph\"]} ]"

            // TODO: get author URL
            let disposable = self.telegraph.createPage(accessToken: accessToken, title: title, authorName: authorName, authorUrl: nil, content: content)
                .observeOn(MainScheduler.instance)
                .subscribe(onNext: { page in

                    self.page.value = page
                    
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
