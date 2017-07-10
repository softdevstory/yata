//
//  InputLinkSheetController.swift
//  yata
//
//  Created by HS Song on 2017. 7. 7..
//  Copyright © 2017년 HS Song. All rights reserved.
//

import AppKit

import RxSwift
import RxCocoa

enum InputLinkSheetResult {
    case none
    case cancel
    case ok(link: String)
    case deleteLink
}

class InputLinkSheetController: NSViewController {

    @IBOutlet weak var linkTextField: NSTextField!
    @IBOutlet weak var deleteLinkButton: NSButton!
    @IBOutlet weak var okButton: NSButton!
    @IBOutlet weak var cancelButton: NSButton!

    let bag = DisposeBag()
    
    var result = Variable<InputLinkSheetResult>(.none)
    
    var initialLinkString = Variable<String>("")
    
    override var nibName: String? {
        return "InputLinkSheet"
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureUi()
    }

    private func configureUi() {
        initialLinkString.asObservable()
            .subscribe(onNext: { value in
                self.linkTextField.stringValue = value
            })
            .disposed(by: bag)
        
        cancelButton.rx.tap
            .subscribe(onNext: {
                self.result.value = .cancel
                self.dismiss(self)
            })
            .disposed(by: bag)

        deleteLinkButton.rx.tap
            .subscribe(onNext: {
                self.result.value = .deleteLink
                self.dismiss(self)
            })
            .disposed(by: bag)
        
        okButton.rx.tap
            .subscribe(onNext: {
                self.result.value = .ok(link: self.linkTextField.stringValue)
                self.dismiss(self)
            })
            .disposed(by: bag)
    }
}
