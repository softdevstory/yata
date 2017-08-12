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

    var totalPageCount = 0
    
    private let bag = DisposeBag()
    
    var pages: Variable<[Page]> = Variable<[Page]>([])
    
    func numberOfRows() -> Int {
        return pages.value.count
    }
    
    func isLastRow(row: Int) -> Bool {
        if row == pages.value.count - 1 {
            return true
        } else {
            return false
        }
    }
    
    func getPage(row: Int) -> Observable<Page> {
        let observable = Observable<Page>.create { observer in
            let page = self.pages.value[row]
                
            if let _ = page.content {
                observer.onNext(page)
                observer.onCompleted()
            } else {
                guard let path = page.path else {
                    observer.onError(YataError.NoPagePath)
                    return Disposables.create()
                }
                
                self.telegraph.getPage(path: path)
                    .observeOn(MainScheduler.instance)
                    .subscribe(onNext: { page in
                        
                        self.pages.value[row].content = page.content
                        
                        observer.onNext(page)
                        observer.onCompleted()
                        
                    }, onError: { error in
                        observer.onError(error)
                    })
                    .disposed(by: self.bag)
            }

            return Disposables.create()
        }
        
        return observable
    }
    
    func loadNextPageList() -> Observable<Void> {
    
        let observable = Observable<Void>.create { observer in
            if self.pages.value.count >= self.totalPageCount {
                observer.onCompleted()
                return Disposables.create()
            }
        
            guard let accessToken = AccessTokenStorage.loadAccessToken() else {
                observer.onError(YataError.NoAccessToken)
                return Disposables.create()
            }

            let disposable = self.telegraph.getPageList(accessToken: accessToken, offset: self.pages.value.count)
                .observeOn(MainScheduler.instance)
                .subscribe(onNext: { pageList in

                    self.totalPageCount = pageList.totalCount!
                    
                    self.pages.value.append(contentsOf: pageList.pages!)
                    
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

    func loadPageList() -> Observable<Void> {
        let observable = Observable<Void>.create { observer in
        
            guard let accessToken = AccessTokenStorage.loadAccessToken() else {
                observer.onError(YataError.NoAccessToken)
                return Disposables.create()
            }

            let disposable = self.telegraph.getPageList(accessToken: accessToken)
                .observeOn(MainScheduler.instance)
                .subscribe(onNext: { pageList in

                    self.totalPageCount = pageList.totalCount!
                    
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
}
