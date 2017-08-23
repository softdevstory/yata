//
//  Window.swift
//  yata
//
//  Created by HS Song on 2017. 8. 23..
//  Copyright © 2017년 HS Song. All rights reserved.
//

import Cocoa

class Window: NSWindow {
    override func validateMenuItem(_ menuItem: NSMenuItem) -> Bool {

        if let tag = MenuTag(rawValue: menuItem.tag) {
        
            switch tag {
            case .viewToggleToolBar:
                if let toolbar = toolbar {
                    if toolbar.isVisible {
                        menuItem.title = "Hide Toolbar".localized
                    } else {
                        menuItem.title = "Show Toolbar".localized
                    }
                } else {
                    return false
                }
                
            default:
                break
            }
        }
         return super.validateMenuItem(menuItem)
    }
}

