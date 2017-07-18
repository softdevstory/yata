//
//  ButtonToolbarItem.swift
//  yata
//
//  Created by HS Song on 2017. 7. 18..
//  Copyright © 2017년 HS Song. All rights reserved.
//

import AppKit

class ButtonToolbarItem: NSToolbarItem {

    // The default implementation of this method does nothing. Overriding this
    // will allow any responder object to validate the toolbar item.
    override func validate() {
        guard let action = action else {
            return
        }
        
        guard let responder = NSApp.target(forAction: action, to: target, from: self) else {
            return
        }
        
        if (responder as AnyObject).responds(to: #selector(validateToolbarItem(_:))) {
            isEnabled = (responder as AnyObject).validateToolbarItem(self)
        }
    }
}
