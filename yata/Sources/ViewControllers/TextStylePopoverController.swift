//
//  TextStylePopoverController.swift
//  yata
//
//  Created by HS Song on 2017. 7. 7..
//  Copyright © 2017년 HS Song. All rights reserved.
//

import AppKit

class TextStylePopoverController: NSViewController {


    @IBOutlet weak var titleButton: NSButton!
    @IBOutlet weak var headerButton: NSButton!
    @IBOutlet weak var bodyButton: NSButton!
    
    override var nibName: String? {
        return "TextStylePopover"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
     
           
    }
    
}
