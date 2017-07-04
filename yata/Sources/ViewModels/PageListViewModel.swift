//
//  PageListViewModel.swift
//  yata
//
//  Created by HS Song on 2017. 7. 4..
//  Copyright © 2017년 HS Song. All rights reserved.
//

import Foundation

import RxSwift

class PageListViewModel {

    private let telegraph = Telegraph.shared

    var pages: Variable<[Page]> = Variable<[Page]>([])
    
    func numberOfRows() -> Int {
        return pages.value.count
    }
    
    func getPage(row: Int) -> Page {
        let page = pages.value[row]
        
        if page.content == nil {
            // request page content?
        }
        
        return page
    }
    
    // TODO: load partially
    func loadPageList(accessToken: String) -> Observable<Void> {
        let observable = Observable<Void>.create { observer in
        
//            guard let accessToken = AccessTokenStorage.loadAccessToken() else {
//                observer.onError(YataError.NoAccessToken)
//                return Disposables.create()
//            }

            let disposable = self.telegraph.getPageList(accessToken: accessToken)
                .observeOn(MainScheduler.instance)
                .subscribe(onNext: { pageList in

                    self.pages.value = pageList.pages!
                    
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
    
    func loadPage(row: Int) -> Observable<Void> {
        let page = pages.value[row]
        
        let observable = Observable<Void>.create { observer in
            guard let path = page.path else {
                observer.onError(YataError.NoPagePath)
                return Disposables.create()
            }

            let disposable = self.telegraph.getPage(path: path)
                .observeOn(MainScheduler.instance)
                .subscribe(onNext: { page in
                    
                    self.pages.value[row].content = page.content
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
