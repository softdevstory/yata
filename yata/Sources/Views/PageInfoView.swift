//
//  PageInfoView.swift
//  yata
//
//  Created by HS Song on 2017. 6. 22..
//  Copyright © 2017년 HS Song. All rights reserved.
//

import AppKit
import Then
import RxSwift

class PageInfoView: NSTableCellView {

    @IBOutlet weak var titleLabel: NSTextField!
    @IBOutlet weak var viewCountLabel: NSTextField!
    @IBOutlet weak var descriptionLabel: NSTextField!
    @IBOutlet weak var contentLabel: NSTextField!
    
    let bag = DisposeBag()
    
    let titleString = Variable<String>("")
    let viewCount = Variable<Int>(0)
    let descriptionString = Variable<String>("")
    let contentString = Variable<String>("")
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func awakeFromNib() {
        titleString.asObservable()
            .subscribe(onNext: { value in
                self.titleLabel.stringValue = value
            })
            .addDisposableTo(bag)
        
        viewCount.asObservable()
            .subscribe(onNext: { value in
                self.viewCountLabel.stringValue = "\(value)"
            })
            .addDisposableTo(bag)
        
        descriptionString.asObservable()
            .subscribe(onNext: { value in
                self.descriptionLabel.stringValue = value
            })
            .addDisposableTo(bag)
        
        contentString.asObservable()
            .subscribe(onNext: { value in
                self.contentLabel.stringValue = value
            })
            .addDisposableTo(bag)
    }
}
