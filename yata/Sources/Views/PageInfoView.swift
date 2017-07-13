//
//  PageInfoView.swift
//  yata
//
//  Created by HS Song on 2017. 6. 22..
//  Copyright © 2017년 HS Song. All rights reserved.
//

import AppKit
import RxSwift

class PageInfoView: NSTableCellView {

    @IBOutlet weak var titleLabel: NSTextField!
    @IBOutlet weak var viewCountLabel: NSTextField!
    @IBOutlet weak var authorNameLabel: NSTextField!
    @IBOutlet weak var contentLabel: NSTextField!
    
    let bag = DisposeBag()
    
    let titleString = Variable<String>("")
    let viewCount = Variable<Int>(0)
    let authorNameString = Variable<String>("")
    let contentString = Variable<String>("")
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func awakeFromNib() {
        contentLabel.maximumNumberOfLines = 3
        
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
        
        authorNameString.asObservable()
            .subscribe(onNext: { value in
                self.authorNameLabel.stringValue = value
            })
            .addDisposableTo(bag)
        
        contentString.asObservable()
            .subscribe(onNext: { value in
                self.contentLabel.stringValue = value
            })
            .addDisposableTo(bag)
    }
}
