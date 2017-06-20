//
//  MainWindowController.swift
//  yata
//
//  Created by HS Song on 2017. 6. 20..
//  Copyright © 2017년 HS Song. All rights reserved.
//


import AppKit
import SnapKit

class MainWindowController: WindowController {

    let splitViewController = MainSplitViewController()
    
    init() {
        super.init(windowSize: CGSize(width: 800, height: 600))

        self.contentView.addSubview(splitViewController.view)
        
        splitViewController.view.snp.makeConstraints { maker in
            maker.top.equalTo(self.contentView)
            maker.bottom.equalTo(self.contentView)
            maker.leading.equalTo(self.contentView)
            maker.trailing.equalTo(self.contentView)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
