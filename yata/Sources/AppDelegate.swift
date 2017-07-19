//
//  AppDelegate.swift
//  yata
//
//  Created by HS Song on 2017. 6. 12..
//  Copyright © 2017년 HS Song. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
    }
}

// MARK: Menu
extension AppDelegate {
    @IBAction func showPreferences(_ sender: Any?) {
        PreferencesWindowController.shared.showWindow(sender)
    }
    
    @IBAction func showAcknowledgements(_ sender: Any?) {
        AcknowledgementsWindowController.shared.showWindow(sender)
    }
}
