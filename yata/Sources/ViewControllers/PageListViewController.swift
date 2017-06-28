//
//  PageListViewController.swift
//  yata
//
//  Created by HS Song on 2017. 6. 19..
//  Copyright © 2017년 HS Song. All rights reserved.
//

import AppKit
import SnapKit

import Moya
import RxSwift

class PageListViewController: NSViewController {

//    @IBOutlet weak var sidebarScrollView: NSScrollView!
    @IBOutlet weak var tableView: NSTableView!
    
    let bag = DisposeBag()
    let provider = RxMoyaProvider<TelegraphApi>()
    
    var pages: [Page] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

     loadPageList()

    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
    }
}


// MARK: telegra.ph

extension PageListViewController {
    func loadPageList() {

        let param = GetPageListParameter(
            accessToken: "b968da509bb76866c35425099bc0989a5ec3b32997d55286c657e6994bbb",
            offset: nil,
            limit: nil)
        
        provider.request(.getPageList(parameter: param))
            .filterSuccessfulStatusCodes()
            .mapJSON()
            .map { data in
                return data as? [String: Any]
            }
            .filter { $0 != nil }
            .subscribe(onNext: { value in
                guard let value = value else { return }
                if let ok = value["ok"] as? Bool, ok {
                    if let result = value["result"] as? [String: Any] {
                        if let pageList = PageList(JSON: result) {
                            self.pages = pageList.pages!

                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
                        }
                    }
                } else {
                    print(value["error"] as? String ?? "")
                }
            })
            .addDisposableTo(bag)
    }
    
    func loadPage(_ page: Page) {
        guard let path = page.path else { return }
        
        let param = GetPageParameter(path: path, returnContent: true)
        
        provider.request(.getPage(parameter: param))
            .filterSuccessfulStatusCodes()
            .mapJSON()
            .map { data in
                return data as? [String: Any]
            }
            .filter { $0 != nil }
            .subscribe(onNext: { value in
                guard let value = value else { return}
                
                if let ok = value["ok"] as? Bool, ok {
                    if let result = value["result"] as? [String: Any] {
                        if let resultPage = Page(JSON: result) {
                            page.content = resultPage.content
                            self.updatePageEditView(with: page)
                        }
                    }
                } else {
                    print(value["error"] as? String ?? "")
                }
            })
            .addDisposableTo(bag)
    }
}

//
extension PageListViewController {
    func updatePageEditView(with page: Page) {
        let notification = Notification(name: Notification.Name(rawValue: "updatePageEditView"), object: page, userInfo: nil)
        NotificationQueue.default.enqueue(notification, postingStyle: .now)
    }
}

// MARK: Table View Data Source
extension PageListViewController: NSTableViewDataSource {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return pages.count
    }
}


// MARK: Table View Delegate
extension PageListViewController: NSTableViewDelegate {
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let pageInfoView = tableView.make(withIdentifier: "PageInfoView", owner: self) as? PageInfoView
        if pageInfoView == nil {
            return nil
        }
        
        pageInfoView?.titleString.value = pages[row].title!
        pageInfoView?.viewCount.value = pages[row].views!
        pageInfoView?.descriptionString.value = pages[row].description!
        pageInfoView?.contentString.value = "first line\nsecond line\nthird line\nforth line"
        
        return pageInfoView
    }

    func tableViewSelectionDidChange(_ notification: Notification) {
        let page = pages[tableView.selectedRow]

        if page.content == nil {
            loadPage(page)
        } else {
            updatePageEditView(with: page)
        }
    }
}


