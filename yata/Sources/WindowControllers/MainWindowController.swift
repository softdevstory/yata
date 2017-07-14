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

        window?.title = "YATA".localized
        
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
    case TextTool = "Text Tool"
    case TextStyle = "Text Style"
    case ViewInWebBrowser = "View In Web Browser"
}

// MARK: Toolbar
extension MainWindowController: NSToolbarDelegate {
    func toolbarAllowedItemIdentifiers(_ toolbar: NSToolbar) -> [String] {
        return [ToolbarItem.Reload.rawValue,
                ToolbarItem.NewPage.rawValue,
                ToolbarItem.TextTool.rawValue,
                ToolbarItem.TextStyle.rawValue,
                ToolbarItem.ViewInWebBrowser.rawValue,
                NSToolbarFlexibleSpaceItemIdentifier,
                NSToolbarSpaceItemIdentifier,
                NSToolbarSeparatorItemIdentifier]
    }
    
    func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [String] {
        Swift.print("default toolbar items")
        return [ToolbarItem.Reload.rawValue,
                ToolbarItem.NewPage.rawValue,
                NSToolbarSpaceItemIdentifier,
                ToolbarItem.TextTool.rawValue,
                ToolbarItem.TextStyle.rawValue,
                NSToolbarFlexibleSpaceItemIdentifier,
                ToolbarItem.ViewInWebBrowser.rawValue]
    }
    
    private func buildToolbarButton(image: NSImage) -> NSButton {
        let button = NSButton(frame: NSRect(x: 0, y: 0, width: 40, height: 40))
        button.image = image
        button.image?.size = NSSize(width: 17, height: 17)
        button.bezelStyle = .texturedRounded
        
        return button
    }
    
    func toolbar(_ toolbar: NSToolbar, itemForItemIdentifier itemIdentifier: String, willBeInsertedIntoToolbar flag: Bool) -> NSToolbarItem? {
        let toolbarItem: NSToolbarItem = NSToolbarItem(itemIdentifier: itemIdentifier)
        
        switch itemIdentifier {
        case ToolbarItem.Reload.rawValue:
            let button = buildToolbarButton(image: #imageLiteral(resourceName: "icons8-synchronize"))
            button.action = #selector(MainSplitViewController.reloadPageList(_:))
            
            toolbarItem.view = button
            toolbarItem.label = itemIdentifier.localized
            toolbarItem.paletteLabel = itemIdentifier.localized
            
        case ToolbarItem.NewPage.rawValue:
            let button = buildToolbarButton(image: #imageLiteral(resourceName: "icons8-create_new"))
            button.action = #selector(MainSplitViewController.editNewPage(_:))
            
            toolbarItem.view = button
            toolbarItem.label = itemIdentifier.localized
            toolbarItem.paletteLabel = itemIdentifier.localized
            
        case ToolbarItem.TextStyle.rawValue:
            let button = buildToolbarButton(image: #imageLiteral(resourceName: "icons8-lowercase"))
            button.action = #selector(PageEditViewController.togglePopover(_:))
            
            toolbarItem.view = button
            toolbarItem.label = itemIdentifier.localized
            toolbarItem.paletteLabel = itemIdentifier.localized
            
        case ToolbarItem.ViewInWebBrowser.rawValue:
            let button = buildToolbarButton(image: #imageLiteral(resourceName: "icons8-internet"))
            button.action = #selector(PageListViewController.viewInWebBrowser(_:))
            
            toolbarItem.view = button
            toolbarItem.label = itemIdentifier.localized
            toolbarItem.paletteLabel = itemIdentifier.localized

        case ToolbarItem.TextTool.rawValue:
            let segment = NSSegmentedControl(frame: NSRect(x: 0, y: 0, width: 120, height: 40))
            segment.segmentStyle = .texturedRounded
            segment.segmentCount = 3
            segment.trackingMode = .momentary

            segment.target = nil
            segment.action = #selector(PageEditViewController.testMenu(_:))

            let cell = segment.cell as? NSSegmentedCell
            
            var image = #imageLiteral(resourceName: "icons8-bold")
            image.size = NSSize(width: 20, height: 20)
            segment.setLabel("B", forSegment: 0)
//            segment.setImage(image, forSegment: 0)
            segment.setWidth(30, forSegment: 0)
            cell?.setTag(0, forSegment: 0)
            
            image = #imageLiteral(resourceName: "icons8-italic")
            image.size = NSSize(width: 20, height: 20)
//            segment.setImage(image, forSegment: 1)
            segment.setLabel("I", forSegment: 1)
            segment.setWidth(30, forSegment: 1)
            cell?.setTag(1, forSegment: 1)
            
            image = #imageLiteral(resourceName: "icons8-link_filled")
            image.size = NSSize(width: 20, height: 20)
//            segment.setImage(image, forSegment: 2)
            segment.setLabel("L", forSegment: 2)
            segment.setWidth(30, forSegment: 2)
            cell?.setTag(2, forSegment: 2)

//            let group = NSToolbarItemGroup(itemIdentifier: ToolbarItem.TextTool.rawValue)
//            let itemA = NSToolbarItem(itemIdentifier: "Bold")
//            itemA.label = "Bold"
//            let itemB = NSToolbarItem(itemIdentifier: "Italic")
//            itemB.label = "Italic"
//            let itemC = NSToolbarItem(itemIdentifier: "Link")
//            itemC.label = "Link"
//            
//            group.paletteLabel = itemIdentifier.localized
//            group.subitems = [itemA, itemB, itemC]
//            group.view = segment
//            toolbarItem = group

            toolbarItem.view = segment
            toolbarItem.label = itemIdentifier.localized
            toolbarItem.paletteLabel = itemIdentifier.localized

        default:
            break
        }
        
        return toolbarItem
    }
}

