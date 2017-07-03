//
//  Alert.swift
//  yata
//
//  Created by HS Song on 2017. 6. 30..
//  Copyright © 2017년 HS Song. All rights reserved.
//

import Cocoa

func alertSheetModal(for window: NSWindow, message: String, information: String?) {
    let alert = NSAlert()
    
    alert.messageText = message
    if let information = information {
        alert.informativeText = information
    }
    
    alert.addButton(withTitle: "OK")
    alert.alertStyle = .critical
    
    alert.beginSheetModal(for: window, completionHandler: nil)
}
