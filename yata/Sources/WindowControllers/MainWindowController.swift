//
//  MainWindowController.swift
//  yata
//
//  Created by HS Song on 2017. 6. 20..
//  Copyright © 2017년 HS Song. All rights reserved.
//


import AppKit

class MainWindowController: NSWindowController {

    @IBOutlet weak var toolbar: NSToolbar!
    
    override func windowDidLoad() {
    
        toolbar.delegate = self
        customizePopupMenuOfToolbar()
    }
    
    private func customizePopupMenuOfToolbar() {
        // Customize popup menu of toolbar
        // from https://stackoverflow.com/questions/39622468/display-only-customize-toolbar-in-nstoolbars-context-menu-in-swift
        if let contextMenu = window?.contentView?.superview?.menu {
            contextMenu.items.forEach({ (item) in
                if let action = item.action,
                    NSStringFromSelector(action) != "runToolbarCustomizationPalette:" {
                    contextMenu.removeItem(item)
                }
            })
        }
    }
}

// MARK: NSWindowDelegate
// from https://stackoverflow.com/questions/39622468/display-only-customize-toolbar-in-nstoolbars-context-menu-in-swift
extension MainWindowController: NSWindowDelegate {

    func window(_ window: NSWindow, willPositionSheet sheet: NSWindow, using rect: NSRect) -> NSRect {
        if sheet.className == "NSToolbarConfigPanel" {
            removeSizeAndDisplayMode(in: sheet)
        }

        return rect
    }
    
    private func removeSizeAndDisplayMode(in sheet: NSWindow) {

        guard let views = sheet.contentView?.subviews else { return }
        
        // Hide Small Size Option
        views.lazy
            .flatMap { $0 as? NSButton }
            .filter { button -> Bool in
                guard let buttonTypeValue = button.cell?.value(forKey: "buttonType") as? UInt,
                    let buttonType = NSButtonType(rawValue: buttonTypeValue)
                    else { return false }
                return buttonType == .switch
            }
            .first?.isHidden = true
        
        // Hide Display Mode Option
        views.lazy
            .filter { view -> Bool in
                return view.subviews.count == 2
            }
            .first?.isHidden = true
        
        sheet.contentView?.needsDisplay = true
    }
}

enum ToolbarItem: String {
    case Reload = "Reload"
    case NewPage = "New Page"
}

// MARK: Toolbar
extension MainWindowController: NSToolbarDelegate {
    func toolbarAllowedItemIdentifiers(_ toolbar: NSToolbar) -> [String] {
        return [ToolbarItem.Reload.rawValue,
                ToolbarItem.NewPage.rawValue,
                NSToolbarFlexibleSpaceItemIdentifier,
                NSToolbarSpaceItemIdentifier,
                NSToolbarSeparatorItemIdentifier]
    }
    
    func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [String] {
        return [ToolbarItem.Reload.rawValue,
                ToolbarItem.NewPage.rawValue]
    }
    
    func toolbar(_ toolbar: NSToolbar, itemForItemIdentifier itemIdentifier: String, willBeInsertedIntoToolbar flag: Bool) -> NSToolbarItem? {
        let toolbarItem: NSToolbarItem = NSToolbarItem(itemIdentifier: itemIdentifier)
        
        switch itemIdentifier {
        case ToolbarItem.Reload.rawValue:
            let button = NSButton(frame: NSRect(x: 0, y: 0, width: 40, height: 40))
            button.image = #imageLiteral(resourceName: "icons8-synchronize")
            button.image?.size = NSSize(width: 17, height: 17)
            button.bezelStyle = .texturedRounded
            
            toolbarItem.view = button
            toolbarItem.label = itemIdentifier.localized
            toolbarItem.paletteLabel = itemIdentifier.localized
            
        case ToolbarItem.NewPage.rawValue:
            let button = NSButton(frame: NSRect(x: 0, y: 0, width: 40, height: 40))
            button.image = #imageLiteral(resourceName: "icons8-create_new")
            button.image?.size = NSSize(width: 17, height: 17)
            button.bezelStyle = .texturedRounded

            toolbarItem.view = button
            toolbarItem.label = itemIdentifier.localized
            toolbarItem.paletteLabel = itemIdentifier.localized
            
        default:
            break
        }
        
        return toolbarItem
    }
}

