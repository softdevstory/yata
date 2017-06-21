//
//  NSMenu+.swift
//  yata
//
//  Created by HS Song on 2017. 6. 21..
//  Copyright © 2017년 HS Song. All rights reserved.
//

import AppKit

extension NSMenu {

    @discardableResult
    func addItem(withTitle string: String, action selector: Selector?, keyEquivalent charCode: String, keyEquivalentModifierMask modifier: NSEventModifierFlags = [.command]) -> NSMenuItem {
        
        let menuItem = NSMenuItem(title: string, action: selector, keyEquivalent: charCode, keyEquivalentModifierMask: modifier)
        
        self.addItem(menuItem)
        
        return menuItem
    }
}
