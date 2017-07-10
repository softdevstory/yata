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

    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var spinnerView: NSProgressIndicator!
    
    let bag = DisposeBag()
    
    let viewModel = PageListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.pages.asObservable()
            .subscribe(onNext: { value in

            })
            .disposed(by: bag)
        
        loadPageList()
        
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
    }

    fileprivate func startSpinner() {
        spinnerView.isHidden = false
        spinnerView.startAnimation(self)
    }
    
    fileprivate func stopSpinner() {
        spinnerView.stopAnimation(self)
        spinnerView.isHidden = true
    }
}


// MARK: telegra.ph

extension PageListViewController {

    func loadPageList() {

        startSpinner()
        
        // Test parameter
        viewModel.loadPageList(accessToken: "b968da509bb76866c35425099bc0989a5ec3b32997d55286c657e6994bbb")
            .subscribe(onNext: nil, onError: { error in
                self.stopSpinner()
                
                let alert = NSAlert(error: error)
                alert.beginSheetModal(for: self.view.window!, completionHandler: nil)
            }, onCompleted: {
                self.tableView.reloadData()
                
                self.stopSpinner()
            })
            .disposed(by: bag)
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
        return viewModel.numberOfRows()
    }
}


// MARK: Table View Delegate
extension PageListViewController: NSTableViewDelegate {
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard let pageInfoView = tableView.make(withIdentifier: "PageInfoView", owner: self) as? PageInfoView else {
            return nil
        }
        
        let page = viewModel.getPage(row: row)

        pageInfoView.titleString.value = page.title!
        pageInfoView.viewCount.value = page.views!
        pageInfoView.descriptionString.value = page.description!
        
        if let _ = page.content {
            pageInfoView.contentString.value = page.string
        } else {
            viewModel.loadPage(row: row)
                .observeOn(MainScheduler.instance)
                .subscribe(onNext: nil, onError: { error in
                    // error
                }, onCompleted: {
                    pageInfoView.descriptionString.value = page.string
                })
                .disposed(by: bag)
        }
        
        return pageInfoView
    }

    func tableViewSelectionDidChange(_ notification: Notification) {
        let page = viewModel.getPage(row: self.tableView.selectedRow)

        if page.content == nil {
            viewModel.loadPage(row: self.tableView.selectedRow)
                .observeOn(MainScheduler.instance)
                .subscribe(onNext: nil, onError: { error in
                    
                }, onCompleted: {
                    let page = self.viewModel.getPage(row: self.tableView.selectedRow)
                    
                    self.updatePageEditView(with: page)
                })
                .disposed(by: bag)
        } else {
            updatePageEditView(with: page)
        }
    }
}


