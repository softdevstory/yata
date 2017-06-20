//
//  main.swift
//  yata
//
//  Created by HS Song on 2017. 6. 20..
//  Copyright © 2017년 HS Song. All rights reserved.
//

import Cocoa

autoreleasepool {
    let app = NSApplication.shared()
    let delegate = AppDelegate()
    
    app.delegate = delegate
    app.run()
}
