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
        
        // TODO: Test parameter
        viewModel.loadPageList()
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
    func updatePageEditView(with page: Page?) {
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
        pageInfoView.authorNameString.value = page.authorName ?? ""
        
        if let _ = page.content {
            pageInfoView.contentString.value = page.string
        } else {
            viewModel.loadPage(row: row)
                .observeOn(MainScheduler.instance)
                .subscribe(onNext: nil, onError: { error in
                    // error
                }, onCompleted: {
                    pageInfoView.contentString.value = page.string
                })
                .disposed(by: bag)
        }
        
        return pageInfoView
    }

    func tableViewSelectionDidChange(_ notification: Notification) {
        // deselected
        if tableView.selectedRow < 0 {
            updatePageEditView(with: nil)
            return
        }

        let page = viewModel.getPage(row: self.tableView.selectedRow)

        if page.content == nil {
            viewModel.loadPage(row: self.tableView.selectedRow)
                .observeOn(MainScheduler.instance)
                .subscribe(onNext: nil, onError: { error in
                    
                }, onCompleted: {
                    let page = self.viewModel.getPage(row: self.tableView.selectedRow)
            
                    if let title = page.title {
                        self.view.window?.title = title
                    }
                    self.updatePageEditView(with: page)
                })
                .disposed(by: bag)
        } else {
            if let title = page.title {
                view.window?.title = title
            }
            
            updatePageEditView(with: page)
        }
    }
}

// Toolback action 

extension PageListViewController {

    func editNewPage(_ sender: Any?) {
        if tableView.selectedRow >= 0 {
            tableView.deselectRow(tableView.selectedRow)
        }
        
        view.window?.title = "New Page".localized
    }
    
    func reloadPageList(_ sender: Any?) {
        loadPageList()
    }

    func viewInWebBrowser(_ sender: Any?) {
        guard tableView.selectedRow >= 0 else {
            return
        }
        
        let page = viewModel.getPage(row: tableView.selectedRow)
        
        if let urlString = page.url?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
            let url = URL(string: urlString) {
            
            NSWorkspace.shared().open(url)
        }
    }
}
