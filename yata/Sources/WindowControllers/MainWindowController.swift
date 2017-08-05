//
//  MainWindowController.swift
//  yata
//
//  Created by HS Song on 2017. 6. 20..
//  Copyright © 2017년 HS Song. All rights reserved.
//


import AppKit

import RxSwift
import Then

class MainWindowController: NSWindowController {

    fileprivate let bag = DisposeBag()
    
    fileprivate let textStylePopover = NSPopover()
    fileprivate let textStylePopoverViewController = TextStylePopoverViewController()

    var noAccountViewController: NoAccountViewController!
    var mainSplitViewController: MainSplitViewController!
    
    var isNoAccount = true

    override func windowDidLoad() {
        super.windowDidLoad()

        setupTextStylePopover()

        guard let window = window else {
            return
        }
        
        window.title = "YATA".localized
        
        let toolbar = NSToolbar(identifier: "MainToolbar")
        toolbar.allowsUserCustomization = true
        toolbar.displayMode = .iconOnly
        toolbar.sizeMode = .small
        toolbar.delegate = self

        window.toolbar = toolbar

        loadViewControllers()
        
        customizePopupMenuOfToolbar()
        
        if let _ = AccessTokenStorage.loadAccessToken() {
            isNoAccount = false
            contentViewController = mainSplitViewController
        } else {
            isNoAccount = true
            contentViewController = noAccountViewController
        }
    }
    
    private func loadViewControllers() {
        let sb = NSStoryboard(name: "Main", bundle: nil)
        
        mainSplitViewController = sb.instantiateController(withIdentifier: "mainSplitViewController") as? MainSplitViewController
        
        noAccountViewController = sb.instantiateController(withIdentifier: "noAccountViewController") as? NoAccountViewController
    }
    
    private func setupTextStylePopover() {
        textStylePopover.behavior = .transient
        textStylePopover.contentViewController = textStylePopoverViewController
        
        textStylePopoverViewController.result.asObservable()
            .subscribe(onNext: { result in
                guard let editorView = self.window?.firstResponder as? EditorView else {
                    return
                }
                
                switch result {
                case .none:
                    break
                case .titleStyle:
                    editorView.setTitleStyle()
                    self.textStylePopover.close()
                case .headerStyle:
                    editorView.setHeaderStyle()
                    self.textStylePopover.close()
                case .bodyStyle:
                    editorView.setBodyStyle()
                    self.textStylePopover.close()
                case .blockQuotationStyle:
                    editorView.setBlockQuoteStyle()
                    self.textStylePopover.close()
                case .pullQuoteStyle:
                    editorView.setPullQuoteStyle()
                    self.textStylePopover.close()
                }
            })
            .disposed(by: bag)
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

// MARK: Toolbar

enum ToolbarItem: String {
    case Reload = "Reload"
    case NewPage = "New Page"
    case TextTool = "Text Tool"
    case TextStyle = "Text Style"
    case ViewInWebBrowser = "View In Web Browser"
}

extension MainWindowController {

    override func validateToolbarItem(_ item: NSToolbarItem) -> Bool {
        
        if isNoAccount {
            return false
        }
        
        switch item.tag {
        case ToolbarTag.paragraphStyle.rawValue:
            guard let _ = window?.firstResponder as? EditorView else {
                return false
            }
        
        case ToolbarTag.textTool.rawValue:
            // checking editorView has a focus
            guard let editorView = window?.firstResponder as? EditorView else {
                return false
            }

            guard let segment = item.view as? NSSegmentedControl else {
                break
            }
            
            if editorView.isBold() {
                segment.setImage(ToolbarIcons.boldChecked, forSegment: 0)
            } else {
                segment.setImage(ToolbarIcons.bold, forSegment: 0)
            }
            
            if editorView.isItalic() {
                segment.setImage(ToolbarIcons.italicChecked, forSegment: 1)
            } else {
                segment.setImage(ToolbarIcons.italic, forSegment: 1)
            }
            
            if let _ = editorView.getCurrentLink() {
                segment.setImage(ToolbarIcons.linkChecked, forSegment: 2)
            } else {
                segment.setImage(ToolbarIcons.link, forSegment: 2)
            }
            
        default:
            break
        }
        
        return true
    }
    
    func reloadPageList(_ sender: Any?) {
        if isNoAccount {
            return
        }

        mainSplitViewController.reloadPageList(sender)
    }
    
    func editNewPage(_ sender: Any?) {
        if isNoAccount {
            return
        }

        mainSplitViewController.editNewPage(sender)
    }
    
    func viewInWebBrowser(_ sender: Any?) {
        if isNoAccount {
            return
        }

        mainSplitViewController.viewInWebBrowser(sender)
    }
    
    func toggleTextStylePopover(_ sender: Any?) {
        guard let editorView = window?.firstResponder as? EditorView else {
            return
        }
        
        guard let button = sender as? NSButton else {
            return
        }
        
        if textStylePopover.isShown {
            textStylePopover.close()
        } else {
            textStylePopoverViewController.textStyle.value = editorView.currentParagraphStyle()
            textStylePopover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
        }
    }
    
    private func showInputLinkSheet(editorView: EditorView) {

        let vc = InputLinkSheetController()

        vc.initialLinkString.value = editorView.getCurrentLink() ?? ""
        
        vc.result.asObservable()
            .subscribe(onNext: { value in
            
                switch value {
                case .cancel, .none:
                    break

                case .ok(let link):
                    editorView.setLink(link: link)
                    
                case .deleteLink:
                    editorView.deleteLink()
                }
            })
            .disposed(by: bag)
        
        contentViewController?.presentViewControllerAsSheet(vc)
    }
    
    func toggleTextTool(_ sender: Any?) {
        guard let segment = sender as? NSSegmentedControl else {
            return
        }
        
        guard let editorView = window?.firstResponder as? EditorView else {
            return
        }
        
        switch segment.selectedSegment {
        case 0:
            editorView.toggleBoldStyle()
        case 1:
            editorView.toggleItalicStyle()
        case 2:
            showInputLinkSheet(editorView: editorView)
        default:
            break
        }
    }
}

// MARK: Toolbar delegate
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
        return [ToolbarItem.Reload.rawValue,
                ToolbarItem.NewPage.rawValue,
                NSToolbarSpaceItemIdentifier,
                ToolbarItem.TextTool.rawValue,
                NSToolbarSpaceItemIdentifier,
                ToolbarItem.TextStyle.rawValue,
                NSToolbarFlexibleSpaceItemIdentifier,
                ToolbarItem.ViewInWebBrowser.rawValue]
    }
    
    private func buildToolbarButton(image: NSImage) -> NSButton {
        let button = NSButton(frame: NSRect(x: 0, y: 0, width: 40, height: 40))
        button.image = image
        button.bezelStyle = .texturedRounded
        
        return button
    }
    
    func toolbar(_ toolbar: NSToolbar, itemForItemIdentifier itemIdentifier: String, willBeInsertedIntoToolbar flag: Bool) -> NSToolbarItem? {
        let toolbarItem: ButtonToolbarItem = ButtonToolbarItem(itemIdentifier: itemIdentifier)
        
        switch itemIdentifier {
        case ToolbarItem.Reload.rawValue:
            let button = buildToolbarButton(image: ToolbarIcons.reload)
            button.action = #selector(MainWindowController.reloadPageList(_:))
            
            toolbarItem.view = button
            toolbarItem.label = itemIdentifier.localized
            toolbarItem.paletteLabel = itemIdentifier.localized
            toolbarItem.tag = ToolbarTag.reloadPageList.rawValue
            
        case ToolbarItem.NewPage.rawValue:
            let button = buildToolbarButton(image: ToolbarIcons.newPage)
            button.action = #selector(MainWindowController.editNewPage(_:))
            
            toolbarItem.view = button
            toolbarItem.label = itemIdentifier.localized
            toolbarItem.paletteLabel = itemIdentifier.localized
            toolbarItem.tag = ToolbarTag.newPage.rawValue
            
        case ToolbarItem.TextStyle.rawValue:
            let button = buildToolbarButton(image: ToolbarIcons.paragraphStyle)
            button.action = #selector(MainWindowController.toggleTextStylePopover(_:))
            
            toolbarItem.view = button
            toolbarItem.label = itemIdentifier.localized
            toolbarItem.paletteLabel = itemIdentifier.localized
            toolbarItem.tag = ToolbarTag.paragraphStyle.rawValue
            
        case ToolbarItem.ViewInWebBrowser.rawValue:
            let button = buildToolbarButton(image: ToolbarIcons.webBrowser)
            button.action = #selector(MainWindowController.viewInWebBrowser(_:))
            
            toolbarItem.view = button
            
            toolbarItem.label = itemIdentifier.localized
            toolbarItem.paletteLabel = itemIdentifier.localized
            toolbarItem.tag = ToolbarTag.viewInWebBrowser.rawValue
            
        case ToolbarItem.TextTool.rawValue:
            let segment = NSSegmentedControl(frame: NSRect(x: 0, y: 0, width: 120, height: 40))
            segment.segmentStyle = .texturedRounded
            segment.segmentCount = 3
            segment.trackingMode = .momentary

            segment.target = nil
            segment.action = #selector(MainWindowController.toggleTextTool(_:))
            
            let cell = segment.cell as? NSSegmentedCell
  
            segment.setImage(ToolbarIcons.bold, forSegment: 0)
            segment.setWidth(30, forSegment: 0)
            cell?.setTag(0, forSegment: 0)
  
            segment.setImage(ToolbarIcons.italic, forSegment: 1)
            segment.setWidth(30, forSegment: 1)
            cell?.setTag(1, forSegment: 1)
            
            segment.setImage(ToolbarIcons.link, forSegment: 2)
            segment.setWidth(30, forSegment: 2)
            cell?.setTag(2, forSegment: 2)

            toolbarItem.view = segment
            toolbarItem.tag = ToolbarTag.textTool.rawValue
            toolbarItem.label = itemIdentifier.localized
            toolbarItem.paletteLabel = itemIdentifier.localized

        default:
            break
        }
        
        return toolbarItem
    }
}

