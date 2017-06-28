//
//  PageEditViewController.swift
//  yata
//
//  Created by HS Song on 2017. 6. 19..
//  Copyright © 2017년 HS Song. All rights reserved.
//

import AppKit
import SnapKit

class PageEditViewController: NSViewController {

    @IBOutlet weak var titleTextField: NSTextField!
    @IBOutlet weak var descriptionTextField: NSTextField!
    @IBOutlet var contentTextView: NSTextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updatePage(_:)), name: NSNotification.Name(rawValue: "updatePageEditView"), object: nil)
    }

    func updatePage(_ notification: Notification) {
        guard let page = notification.object as? Page else { return }

        titleTextField.stringValue = page.title!
        descriptionTextField.stringValue = page.description!
    }
}
