//
//  PageListViewController.swift
//  yata
//
//  Created by HS Song on 2017. 6. 19..
//  Copyright © 2017년 HS Song. All rights reserved.
//

import AppKit

import Moya
import RxSwift

class PageListViewController: NSViewController {

    @IBOutlet weak var tableView: TableView!
    @IBOutlet weak var spinnerView: NSProgressIndicator!
    @IBOutlet weak var scrollView: NSScrollView!
    @IBOutlet weak var noPageLabel: NSTextField!
    
    let bag = DisposeBag()
    
    let viewModel = PageListViewModel()
    
    fileprivate var isContentEdited = false
    fileprivate var isObserverRegistered = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // to set scroller's background transparent
        scrollView.appearance = NSAppearance(named: NSAppearanceNameAqua)
        
        viewModel.pages.asObservable()
            .subscribe(onNext: { pages in
            
            })
            .disposed(by: bag)
        
        loadPageList()
    }
    
    func registerObserver() {
        guard isObserverRegistered == false else {
            return
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateContentModified(_:)), name: NotificationName.contentModifiedState, object: nil)
        isObserverRegistered = true
    }

    func unregisterObserver() {
        guard isObserverRegistered else {
            return
        }
        
        NotificationCenter.default.removeObserver(self)
        isObserverRegistered = false
    }
    
    func updateContentModified(_ notification: Notification) {
        guard let state = notification.object as? Bool else {
            return
        }
        
        isContentEdited = state
    }
    
    fileprivate func setRowsDefaultStyle() {
        tableView.enumerateAvailableRowViews { (rowView, row) -> Void in
            guard let pageInfoView = rowView.view(atColumn: 0) as? PageInfoView else {
                return
            }
            
            pageInfoView.changeDefaultStyle()
        }
    }
    
    fileprivate func setRowSelectedStyle() {
        tableView.enumerateAvailableRowViews { (rowView, row) -> Void in
            guard let pageInfoView = rowView.view(atColumn: 0) as? PageInfoView else {
                return
            }
            
            if row == self.tableView.selectedRow {
                pageInfoView.changeSelectedStyle()
            } else {
                pageInfoView.changeDefaultStyle()
            }
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        guard keyPath == #keyPath(NSWindow.firstResponder) else {
            return
        }
        
        if let tableView = change?[.newKey] as? NSTableView, tableView.tag == 1 {
            setRowSelectedStyle()
        } else {
            setRowsDefaultStyle()
        }
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        
        if let window = view.window {
            window.addObserver(self, forKeyPath: #keyPath(NSWindow.firstResponder), options: [.new, .old], context: nil)
        }
    }
    
    override func viewWillDisappear() {
        if let window = view.window {
            window.removeObserver(self, forKeyPath: #keyPath(NSWindow.firstResponder))
        }
    }

    fileprivate func startSpinner() {
        tableView.isEnabled = false
        
        spinnerView.isHidden = false
        noPageLabel.isHidden = true
        
        spinnerView.startAnimation(self)
    }
    
    fileprivate func stopSpinner() {
        spinnerView.stopAnimation(self)
        
        spinnerView.isHidden = true
        tableView.isEnabled = true
        
        if viewModel.numberOfRows() == 0 {
            noPageLabel.isHidden = false
            tableView.isHidden = true
        } else {
            noPageLabel.isHidden = true
            tableView.isHidden = false
         }
    }
    
    fileprivate func checkDiscardContent() -> Bool {
        let alert = NSAlert()
        alert.messageText = "Content is modified. Do you want to discard it?".localized
        alert.alertStyle = .warning
        alert.addButton(withTitle: "Ok".localized)
        alert.addButton(withTitle: "Cancel".localized)
        let button = alert.runModal()
        if button == NSAlertFirstButtonReturn {
            return true
        } else {
            return false
        }
    }
    
}

// MARK: telegra.ph

extension PageListViewController {

    func loadPageList() {

        startSpinner()
        
        viewModel.loadPageList()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: nil, onError: { error in
                self.stopSpinner()
                
                if let window = self.view.window {
                    let alert = NSAlert(error: error)
                    alert.beginSheetModal(for: window, completionHandler: nil)
                }
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
        registerObserver()
        
        let notification = Notification(name: NotificationName.updatePageEditView, object: page, userInfo: nil)
        NotificationQueue.default.enqueue(notification, postingStyle: .now)
    }
    
    func isSelected() -> Bool {
        if tableView.selectedRow >= 0 {
            return true
        } else {
            return false
        }
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
        
        viewModel.getPage(row: row)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { page in
                pageInfoView.titleString.value = page.title!
                pageInfoView.viewCount.value = page.views!
                pageInfoView.authorNameString.value = page.authorName ?? ""
            
                pageInfoView.contentString.value = page.string
            })
            .disposed(by: bag)
        
        if viewModel.isLastRowAndNeedToLoad(row: row) {
            startSpinner()
            
            viewModel.loadNextPageList()
                .subscribe(onNext: nil, onError: { error in
                    self.stopSpinner()
                    
                    if let window = self.view.window {
                        let alert = NSAlert(error: error)
                        alert.beginSheetModal(for: window, completionHandler: nil)
                    }
                }, onCompleted: {
                    self.tableView.reloadData()
                    
                    self.stopSpinner()
                })
                .disposed(by: bag)
        }
        
        return pageInfoView
    }

    func tableViewSelectionDidChange(_ notification: Notification) {
        // deselected
        if tableView.selectedRow < 0 {
            updatePageEditView(with: nil)
            
            setRowsDefaultStyle()
            
            return
        }

        viewModel.getPage(row: tableView.selectedRow)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { page in
                if let title = page.title {
                    self.view.window?.title = title
                }
                
                self.updatePageEditView(with: page)
            })
            .disposed(by: bag)
        
        setRowSelectedStyle()
    }
    
    func selectionShouldChange(in tableView: NSTableView) -> Bool {
        if isContentEdited {
            return checkDiscardContent()
        } else {
            return true
        }
    }
}

// Toolbar action

extension PageListViewController {

    func editNewPage(_ sender: Any?) {
        if isContentEdited {
            if checkDiscardContent() == false {
                return
            }
        }

        if tableView.selectedRow >= 0 {
            tableView.deselectRow(tableView.selectedRow)
        }
        
        view.window?.title = "New Page".localized
        
        updatePageEditView(with: nil)
    }
    
    func reloadList(_ sender: Any?) {
        loadPageList()
    }

    func openInWebBrowser(_ sender: Any?) {
        guard tableView.selectedRow >= 0 else {
            return
        }

        viewModel.getPage(row: tableView.selectedRow)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { page in
                if let urlString = page.url?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                    let url = URL(string: urlString) {
                    
                    NSWorkspace.shared().open(url)
                }
            })
            .disposed(by: bag)
    }
}
