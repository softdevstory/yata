//
//  PopoverButton.swift
//  yata
//
//  Created by HS Song on 2017. 7. 17..
//  Copyright © 2017년 HS Song. All rights reserved.
//

import AppKit

import SnapKit

import RxSwift
import RxCocoa

class PopoverButton: NSControl {

    private var originalBackgroundColor: NSColor?
    
    private var checkMarkImage = NSImageView(image: #imageLiteral(resourceName: "icons8-checkmark_filled"))
    private var label: NSTextField!

    private var area: NSTrackingArea?
    
    var tap = PublishSubject<Void>()
    
    var isChecked = false {
        didSet {
            if isChecked {
                checkMarkImage.isHidden = false
            } else {
                checkMarkImage.isHidden = true
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(attributedString: NSAttributedString) {
        super.init(frame: NSMakeRect(0, 0, 0, 0))

        label = NSTextField(labelWithAttributedString: attributedString)
        
        wantsLayer = true
    }
    
    override func updateTrackingAreas() {
        if let area = area {
            removeTrackingArea(area)
        }

        area = NSTrackingArea(rect: bounds, options: [.mouseEnteredAndExited, .activeAlways], owner: self, userInfo: nil)
        addTrackingArea(area!)
    }
    
    override func viewDidMoveToWindow() {
        super.viewDidMoveToWindow()
        
        area = NSTrackingArea(rect: bounds, options: [.mouseEnteredAndExited, .activeAlways], owner: self, userInfo: nil)
        addTrackingArea(area!)
        
        originalBackgroundColor = backgroundColor

        addSubview(checkMarkImage)
        checkMarkImage.snp.makeConstraints { maker in
            maker.leading.equalToSuperview().offset(8)
            maker.centerY.equalToSuperview()
            maker.width.equalTo(20)
            maker.height.equalTo(20)
        }

        addSubview(label)
        label.drawsBackground = true
        label.backgroundColor = NSColor.clear
        label.snp.makeConstraints { maker in
            maker.leading.equalToSuperview().offset(36)
            maker.trailing.equalToSuperview().offset(-8)
            maker.centerY.equalToSuperview()
        }
        
        isChecked = false
    }
    
    override func mouseEntered(with event: NSEvent) {
        backgroundColor = NSColor.controlHighlightColor
    }
    
    override func mouseExited(with event: NSEvent) {
        backgroundColor = originalBackgroundColor
    }
    
    override func mouseUp(with event: NSEvent) {
        tap.onNext()
    }
}

