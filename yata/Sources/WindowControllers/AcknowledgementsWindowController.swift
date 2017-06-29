//
//  AcknowledgementsWindowController.swift
//  yata
//
//  Created by HS Song on 2017. 6. 29..
//  Copyright © 2017년 HS Song. All rights reserved.
//

import Cocoa
import WebKit

class AcknowledgementsWindowController: NSWindowController {

    static let shared = AcknowledgementsWindowController()

    @IBOutlet weak var webView: WKWebView!
    
    override var windowNibName: String? {
        return "AcknowledgementsWindow"
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
        guard let fileURL = Bundle.main.url(forResource: FileName.acknowledgements, withExtension: FileName.AcknowledgementsExtension) else { return }

        let request = URLRequest(url: fileURL)
        webView.load(request)
    }
}

extension AcknowledgementsWindowController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
    
        if let url = navigationAction.request.url {
            if url.isFileURL {
                decisionHandler(.allow)
            } else {
                decisionHandler(.cancel)
                
                NSWorkspace.shared().open(url)
            }
        }
    }
}
