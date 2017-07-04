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
    
    func getPageCount() -> Int {
        return pages.value.count
    }
    
    func getPages() -> [Page] {
        return pages.value
    }
    
    // TODO: load partially
    func loadPageList(accessToken: String) -> Observable<Void> {
        let observable = Observable<Void>.create { observer in
            
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
}
