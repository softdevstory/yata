//
//  TextStylePopoverController.swift
//  yata
//
//  Created by HS Song on 2017. 7. 7..
//  Copyright © 2017년 HS Song. All rights reserved.
//

import AppKit

import RxSwift
import RxCocoa

enum TextStylePopoverResult {
    case none
    case titleStyle
    case headerStyle
    case bodyStyle
    case singleQuotationStyle
    case doubleQuotationStyle
}

class TextStylePopoverController: NSViewController {

    @IBOutlet weak var titleButton: NSButton!
    @IBOutlet weak var headerButton: NSButton!
    @IBOutlet weak var bodyButton: NSButton!
    @IBOutlet weak var singleQuotaionButton: NSButton!
    @IBOutlet weak var doubleQuotationButton: NSButton!

    let bag = DisposeBag()

    var result = Variable<TextStylePopoverResult>(.none)
    
    override var nibName: String? {
        return "TextStylePopover"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
     
        configure()
    }
    
    private func configure() {
        titleButton.rx.tap
            .subscribe(onNext: {
                self.result.value = .titleStyle
            })
            .disposed(by: bag)
        
        headerButton.rx.tap
            .subscribe(onNext: {
                self.result.value = .headerStyle
            })
            .disposed(by: bag)
        
        bodyButton.rx.tap
            .subscribe(onNext: {
                self.result.value = .bodyStyle
            })
            .disposed(by: bag)
        
        singleQuotaionButton.rx.tap
            .subscribe(onNext: {
                self.result.value = .singleQuotationStyle
            })
            .disposed(by: bag)
        
        doubleQuotationButton.rx.tap
            .subscribe(onNext: {
                self.result.value = .doubleQuotationStyle
            })
            .disposed(by: bag)
    }
}
