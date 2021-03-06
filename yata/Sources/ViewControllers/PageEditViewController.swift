//
//  PageEditViewController.swift
//  yata
//
//  Created by HS Song on 2017. 6. 19..
//  Copyright © 2017년 HS Song. All rights reserved.
//

import AppKit

import RxSwift
import RxCocoa

class PageEditViewController: NSViewController {

    @IBOutlet weak var headerView: NSView!
    @IBOutlet weak var bodyView: NSScrollView!
    @IBOutlet weak var titleTextField: NSTextField!
    @IBOutlet weak var authorNameTextField: NSTextField!
    @IBOutlet var editorView: EditorView!
    @IBOutlet weak var publishButton: NSButton!
    @IBOutlet weak var emptyLabel: NSTextField!
    
    let bag = DisposeBag()
    
    let viewModel = PageEditViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        editorView.layoutManager?.replaceTextStorage(viewModel.textStorage)
        
        viewModel.title.asObservable()
            .bind(to: titleTextField.rx.text)
            .disposed(by: bag)
        
        viewModel.authorName.asObservable()
            .bind(to: authorNameTextField.rx.text)
            .disposed(by: bag)
        
        viewModel.mode.asObservable()
            .subscribe(onNext: { mode in
                switch mode {
                case .new:
                    self.publishButton.title = "Publish".localized
                case .edit:
                    self.publishButton.title = "Update".localized
                }
            })
            .disposed(by: bag)
        
        titleTextField.rx.text
            .subscribe(onNext: { text in
                self.viewModel.setContentModified()
            })
            .disposed(by: bag)
        
        authorNameTextField.rx.text
            .subscribe(onNext: { text in
                self.viewModel.setContentModified()
            })
            .disposed(by: bag)

        publishButton.rx.tap
            .subscribe(onNext: {
                self.publishButton.isEnabled = false
                
                switch self.viewModel.mode.value {
                case .new:
                    self.viewModel.publisNewPage(title: self.titleTextField.stringValue, authorName: self.authorNameTextField.stringValue)
                        .observeOn(MainScheduler.instance)
                        .subscribe(onNext: nil, onError: { error in
                            self.showErrorModal(error: error)
                            self.publishButton.isEnabled = true
                        }, onCompleted: {
                            self.viewModel.setContentStored()
                            let action = #selector(MainSplitViewController.reloadPageList(_:))
                            NSApp.sendAction(action, to: nil, from: self)
                            
                            self.publishButton.isEnabled = true
                        })
                        .disposed(by: self.bag)
                case .edit:
                    self.viewModel.updatePage(title: self.titleTextField.stringValue, authorName: self.authorNameTextField.stringValue)
                        .observeOn(MainScheduler.instance)
                        .subscribe(onNext: nil, onError: { error in
                            self.showErrorModal(error: error)
                            self.publishButton.isEnabled = true
                        }, onCompleted: {
                            self.viewModel.setContentStored()
                            let action = #selector(MainSplitViewController.reloadPageList(_:))
                            NSApp.sendAction(action, to: nil, from: self)
                            
                            self.publishButton.isEnabled = true
                        })
                        .disposed(by: self.bag)
                }
            })
            .disposed(by: bag)
        
        NotificationCenter.default.addObserver(self, selector: #selector(updatePage(_:)), name: NotificationName.updatePageEditView, object: nil)
        
        view.backgroundColor = NSColor.white
    }
    
    private func showErrorModal(error: Swift.Error) {
        let alert = NSAlert(error: error)
        
        if let error = error as? YataError {
            switch error {
            case .PageTitleRequired:
                alert.messageText = "Title is empty".localized
            case .PageContentTextRequired:
                alert.messageText = "Content is empty".localized
            default:
                alert.messageText = "Unknown error \(error)"
            }
        } else {
            alert.messageText = "Unknown error \(error)"
        }
        
        if let window = view.window {
            alert.beginSheetModal(for: window, completionHandler: nil)
        }
    }
    
    func updatePage(_ notification: Notification) {
        headerView.isHidden = false
        bodyView.isHidden = false
        publishButton.isHidden = false
        emptyLabel.isHidden = true
        
        let page = notification.object as? Page
        viewModel.reset(page: page)
    }
}

// support menu

extension PageEditViewController {
    
    override func validateMenuItem(_ menuItem: NSMenuItem) -> Bool {

        // checking editorView has a focus
        guard let _ = view.window?.firstResponder as? EditorView else {
            return false
        }
        
        guard let tag = MenuTag(rawValue: menuItem.tag) else {
            return false
        }
        
        let paragraphStyle = editorView.currentParagraphStyle()

        menuItem.state = 0
        switch tag {
        case .formatTitle:
            if paragraphStyle == .title {
                menuItem.state = 1
            }
        case .formatHeader:
            if paragraphStyle == .header {
                menuItem.state = 1
            }
        case .formatBody:
            if paragraphStyle == .body {
                menuItem.state = 1
            }
        case .formatBlockQuote:
            if paragraphStyle == .blockQuote {
                menuItem.state = 1
            }
        case .formatPullQuote:
            if paragraphStyle == .pullQuote {
                menuItem.state = 1
            }
            
        case .formatBold:
            if editorView.isBold() {
                menuItem.state = 1
            }
        case .formatItalic:
            if editorView.isItalic() {
                menuItem.state = 1
            }
        case .formatLink:
            if let _ = editorView.getCurrentLink() {
                menuItem.title = "Modify Link".localized
            } else {
                menuItem.title = "Add Link".localized
            }
            
        default:
            return false
        }
    
        return true
    }
    
    @IBAction func selectTitle(_ sender: Any?) {
        editorView.setTitleStyle()
    }
    
    @IBAction func selectHeader(_ sender: Any?) {
        editorView.setHeaderStyle()
    }
    
    @IBAction func selectBody(_ sender: Any?) {
        editorView.setBodyStyle()
    }
    
    @IBAction func selectBlockQuote(_ sender: Any?) {
        editorView.setBlockQuoteStyle()
    }
    
    @IBAction func selectPullQuote(_ sender: Any?) {
        editorView.setPullQuoteStyle()
    }
    
    @IBAction func toggleBold(_ sender: Any?) {
        editorView.toggleBoldStyle()
    }
    
    @IBAction func toggleItalic(_ sender: Any?) {
        editorView.toggleItalicStyle()
    }
    
    @IBAction func setLink(_ sender: Any?) {
        let vc = InputLinkSheetController()

        vc.initialLinkString.value = editorView.getCurrentLink() ?? ""
        
        vc.result.asObservable()
            .subscribe(onNext: { value in
            
                switch value {
                case .cancel, .none:
                    break

                case .ok(let link):
                    self.editorView.setLink(link: link)
                    
                case .deleteLink:
                    self.editorView.deleteLink()
                }
            })
            .disposed(by: bag)
        
        presentViewControllerAsSheet(vc)

    }
}
