//
//  MainSplitViewController.swift
//  yata
//
//  Created by HS Song on 2017. 6. 19..
//  Copyright © 2017년 HS Song. All rights reserved.
//

import Cocoa
import SnapKit

class MainSplitViewController: NSSplitViewController {

    func make1() -> NSViewController {
        let vc1 = NSViewController()
        
        vc1.view = NSView()
        vc1.view.backgroundColor = NSColor.blue
        
        return vc1
    }
    
    func setup1(_ vc1:NSViewController) {
        vc1.view.snp.makeConstraints { maker in
            maker.width.greaterThanOrEqualTo(100)
            maker.width.lessThanOrEqualTo(self.view)
            maker.height.lessThanOrEqualTo(self.view)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        addSplitViewItem(NSSplitViewItem(viewController: PageListViewController()))
        addSplitViewItem(NSSplitViewItem(viewController: PageEditViewController()))

        setup1(splitViewItems[0].viewController)
        setup1(splitViewItems[1].viewController)
    }
    
}
