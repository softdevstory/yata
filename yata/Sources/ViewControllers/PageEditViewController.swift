//
//  PageEditViewController.swift
//  yata
//
//  Created by HS Song on 2017. 6. 19..
//  Copyright © 2017년 HS Song. All rights reserved.
//

import AppKit
import SnapKit
import Then
import RxSwift

class PageEditViewController: NSViewController {

    @IBOutlet weak var titleTextField: NSTextField!
    @IBOutlet weak var descriptionTextField: NSTextField!
    @IBOutlet var contentTextView: EditorView!
    
    let bag = DisposeBag()
    
    let textStylePopover = NSPopover().then {
        let vc = TextStylePopoverController()
        $0.contentViewController = vc
        $0.behavior = .transient
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentTextView.font = NSFont.systemFont(ofSize: NSFont.systemFontSize())
        
        NotificationCenter.default.addObserver(self, selector: #selector(updatePage(_:)), name: NSNotification.Name(rawValue: "updatePageEditView"), object: nil)
    }

    func updatePage(_ notification: Notification) {
        guard let page = notification.object as? Page else { return }

        titleTextField.stringValue = page.title!
        descriptionTextField.stringValue = page.description!
        
        contentTextView.string = page.string
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
