//
//  NSWindowController+.swift
//  yata
//
//  Created by HS Song on 2017. 6. 20..
//  Copyright © 2017년 HS Song. All rights reserved.
//

import Cocoa

extension NSWindowController {
    var contentView: NSView {
        get {
            return self.window!.contentView!
        }
        set {
            self.window!.contentView = newValue
        }
    }
}
