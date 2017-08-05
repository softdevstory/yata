//
//  MainSplitViewController.swift
//  yata
//
//  Created by HS Song on 2017. 7. 14..
//  Copyright © 2017년 HS Song. All rights reserved.
//

import AppKit

class MainSplitViewController: NSSplitViewController {

    
    @IBOutlet weak var pageListSplitViewItem: NSSplitViewItem!
    @IBOutlet weak var pageEditSplitViewItem: NSSplitViewItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}


// MARK: support menu, toolbar 

extension MainSplitViewController {

    override func validateMenuItem(_ menuItem: NSMenuItem) -> Bool {
        guard let tag = MenuTag(rawValue: menuItem.tag) else {
            return false
        }
        
        switch tag {
        case .fileNewPage, .fileReload:
            break
            
        case .fileOpenInWebBrowser:
            if let vc = pageListSplitViewItem.viewController as? PageListViewController {
                return vc.isSelected()
            }
        
        default:
            return false
        }
        
        return true
    }
    
    override func validateToolbarItem(_ item: NSToolbarItem) -> Bool {

        guard let tag = ToolbarTag(rawValue: item.tag) else {
            return false
        }
        
        guard let _ = AccessTokenStorage.loadAccessToken() else {
           return false
        }
        
        switch tag {
        case .newPage, .reloadPageList:
            return true
            
        case .viewInWebBrowser:
            if let vc = pageListSplitViewItem.viewController as? PageListViewController {
                return vc.isSelected()
            }
        
        default:
            return false
        }
        
        return true
    }
    
    @IBAction func reloadPageList(_ sender: Any?) {
        if let vc = pageListSplitViewItem.viewController as? PageListViewController {
            vc.reloadList(sender)
        }
    }
    
    @IBAction func editNewPage(_ sender: Any?) {
        if let vc = pageListSplitViewItem.viewController as? PageListViewController {
            vc.editNewPage(sender)
        }
    }
    
    @IBAction func viewInWebBrowser(_ sender: Any?) {
        if let vc = pageListSplitViewItem.viewController as? PageListViewController {
            vc.openInWebBrowser(sender)
        }
    }
}
