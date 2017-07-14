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

    @IBAction func reloadPageList(_ sender: Any?) {
        if let vc = pageListSplitViewItem.viewController as? PageListViewController {
            vc.reloadPageList(sender)
        }
    }
    
    @IBAction func editNewPage(_ sender: Any?) {
        if let vc = pageListSplitViewItem.viewController as? PageListViewController {
            vc.editNewPage(sender)
        }
    }
}
