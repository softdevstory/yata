//
//  PreferencesWindowController.swift
//  yata
//
//  Created by HS Song on 2017. 6. 28..
//  Copyright © 2017년 HS Song. All rights reserved.
//

import Cocoa

final class PreferencesWindowController: NSWindowController {

    static let shared = PreferencesWindowController()

    private let viewControllers: [NSViewController] = [
        GeneralPaneController(),
        AccountPaneController()
    ]

    override var windowNibName: String? {
        return "PreferencesWindow"
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
        guard let leftmostItem = self.window?.toolbar?.items.first else { return }
        
        self.window?.toolbar?.selectedItemIdentifier = leftmostItem.itemIdentifier
        self.switchView(leftmostItem)
        self.window?.center()
    }
    
    @IBAction func switchView(_ sender: Any?) {
       guard let window = self.window, let toolbarItem = sender as? NSToolbarItem else { return }
        
        // detect clicked icon and select the view to switch
        let newView = self.viewControllers[toolbarItem.tag].view
        
        // remove current view from the main view
        if let subviews = window.contentView?.subviews {
            for view in subviews {
                view.removeFromSuperviewWithoutNeedingDisplay()
            }
        }
        
        // set window title
        window.title = toolbarItem.paletteLabel
        
        // resize window to fit to new view
        var frame = window.frameRect(forContentRect: newView.frame)
        frame.origin = window.frame.origin
        frame.origin.y += window.frame.height - frame.height
        self.window?.setFrame(frame, display: true, animate: true)
        
        // add new view to the main view
        window.contentView?.addSubview(newView)
    }
}
