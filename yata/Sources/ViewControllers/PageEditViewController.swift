//
//  PageEditViewController.swift
//  yata
//
//  Created by HS Song on 2017. 6. 19..
//  Copyright © 2017년 HS Song. All rights reserved.
//

import AppKit

import RxSwift

class PageEditViewController: NSViewController {

    @IBOutlet weak var titleTextField: NSTextField!
    @IBOutlet weak var authorNameTextField: NSTextField!
    @IBOutlet var contentTextView: EditorView!
    @IBOutlet weak var publishButton: NSButton!
    
    let bag = DisposeBag()
    
    let textStylePopover = NSPopover()
    
    let viewModel = PageEditViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentTextView.layoutManager?.replaceTextStorage(viewModel.textStorage)
        
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

        setupTextStylePopover()
        
        publishButton.rx.tap
            .subscribe(onNext: {
                switch self.viewModel.mode.value {
                case .new:
                    self.viewModel.publisNewPage(title: self.titleTextField.stringValue, authorName: self.authorNameTextField.stringValue)
                        .subscribe(onNext: nil, onCompleted: {
                            Swift.print("done")
                        })
                        .disposed(by: self.bag)
                case .edit:
                    self.viewModel.updatePage(title: self.titleTextField.stringValue, authorName: self.authorNameTextField.stringValue)
                        .subscribe(onNext: nil, onCompleted: {
                            Swift.print("done")
                        })
                        .disposed(by: self.bag)
                }
            })
            .disposed(by: bag)
        
        NotificationCenter.default.addObserver(self, selector: #selector(updatePage(_:)), name: NSNotification.Name(rawValue: "updatePageEditView"), object: nil)
    }
    
    private func setupTextStylePopover() {
        let vc = TextStylePopoverController()
        
        textStylePopover.behavior = .transient
        textStylePopover.contentViewController = vc
        
        vc.result.asObservable()
            .subscribe(onNext: { result in
                switch result {
                case .none:
                    break
                case .titleStyle:
                    self.contentTextView.setTitleStyle()
                    self.textStylePopover.close()
                case .headerStyle:
                    self.contentTextView.setHeaderStyle()
                    self.textStylePopover.close()
                case .bodyStyle:
                    self.contentTextView.setBodyStyle()
                    self.textStylePopover.close()
                case .singleQuotationStyle:
                    self.contentTextView.setSingleQuotationStyle()
                    self.textStylePopover.close()
                case .doubleQuotationStyle:
                    self.contentTextView.setDoubleQuotationStyle()
                    self.textStylePopover.close()
                }
            })
            .disposed(by: bag)
    }

    func updatePage(_ notification: Notification) {
        let page = notification.object as? Page
        viewModel.reset(page: page)
    }
}

extension PageEditViewController {

    private func showSheet() {
        let vc = InputLinkSheetController()

        vc.initialLinkString.value = contentTextView.getCurrentLink() ?? ""
        
        vc.result.asObservable()
            .subscribe(onNext: { value in
                switch value {
                case .cancel, .none:
                    break

                case .ok(let link):
                    self.contentTextView.setLink(link: link)
                    
                case .deleteLink:
                    self.contentTextView.deleteLink()
                }
            })
            .disposed(by: bag)
        
        presentViewControllerAsSheet(vc)
    }
    
    func testMenu(_ sender: Any?) {
        guard let segment = sender as? NSSegmentedControl else { return }
        
        switch segment.selectedSegment {
        case 0:
            contentTextView.toggleBoldStyle()
        case 1:
            contentTextView.toggleItalicStyle()
        case 2:
            showSheet()
        default:
            break
        }
    }
    
    func togglePopover(_ sender: Any?) {
        guard let button = sender as? NSButton else {
            return
        }
        
        if textStylePopover.isShown {
            textStylePopover.close()
        } else {
            textStylePopover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
        }
    }
}
