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
    @IBOutlet weak var descriptionTextField: NSTextField!
    @IBOutlet var contentTextView: EditorView!
    @IBOutlet weak var publishButton: NSButton!
    
    let bag = DisposeBag()
    
    let textStylePopover = NSPopover()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentTextView.font = NSFont.systemFont(ofSize: NSFont.systemFontSize())
        
        setupTextStylePopover()
        
        publishButton.rx.tap
            .subscribe(onNext: {
                self.contentTextView.convertText()
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
        if let page = notification.object as? Page {
            titleTextField.stringValue = page.title!
            descriptionTextField.stringValue = page.description!
            
            contentTextView.string = page.string
        } else {
            titleTextField.stringValue = ""
            descriptionTextField.stringValue = ""
            
            contentTextView.resetText()
        }
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
