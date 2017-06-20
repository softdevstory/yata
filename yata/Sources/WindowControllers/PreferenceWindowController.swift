//
//  PreferenceWindowController.swift
//  yata
//
//  Created by HS Song on 2017. 6. 20..
//  Copyright © 2017년 HS Song. All rights reserved.
//

import AppKit

class PreferenceWindowController: WindowController {
    init() {
        super.init(windowSize: CGSize(width: 310, height: 408))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
