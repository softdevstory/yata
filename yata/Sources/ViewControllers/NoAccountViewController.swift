//
//  NoAccountViewController.swift
//  yata
//
//  Created by HS Song on 2017. 7. 25..
//  Copyright © 2017년 HS Song. All rights reserved.
//

import AppKit

class NoAccountViewController: NSViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func openAccountPreference(_ sender: Any) {
        PreferencesWindowController.shared.showWindow(sender)
    }
}
