//
//  NSMenuItem+.swift
//  yata
//
//  Created by HS Song on 2017. 6. 21..
//  Copyright © 2017년 HS Song. All rights reserved.
//

import AppKit

extension NSMenuItem {
    convenience init(title string: String, action selector: Selector?, keyEquivalent charCode: String, keyEquivalentModifierMask modifier: NSEventModifierFlags = [.command]) {
    
        self.init(title: string, action: selector, keyEquivalent: charCode)
        self.keyEquivalentModifierMask = modifier
    }
}
