//
//  AccountPaneController.swift
//  yata
//
//  Created by HS Song on 2017. 6. 28..
//  Copyright © 2017년 HS Song. All rights reserved.
//

import Cocoa
import SnapKit

class AccountPaneController: NSViewController {
    
    private enum Mode {
        case none
        case account
        case createAccount
    }

    @IBOutlet var createAccountView: NSView!
    @IBOutlet var accountView: NSView!

    private var mode = Mode.none
    
    override var nibName: String? {
        return "AccountPane"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        switchCreateAccountView()
    }
    
    func switchAccountView() {
        switch mode {
        case .account:
            break
        case .createAccount:
            createAccountView.removeFromSuperview()
            view.addSubview(accountView)
            view.setFrameSize(accountView.frame.size)
            mode = .account
        case .none:
            view.addSubview(accountView)
            view.setFrameSize(accountView.frame.size)
            mode = .account
        }
    }
    
    func switchCreateAccountView() {
        switch mode {
        case .account:
            accountView.removeFromSuperview()
            view.addSubview(createAccountView)
            view.setFrameSize(createAccountView.frame.size)
            mode = .createAccount
        case .createAccount:
            break
        case .none:
            view.addSubview(createAccountView)
            view.setFrameSize(createAccountView.frame.size)
            mode = .createAccount
        }
    }
    
    func resizeWindow() {
        // resize window to fit to new view
        var frame = view.window?.frameRect(forContentRect: view.frame)
        frame?.origin = (view.window?.frame.origin)!
        frame?.origin.y += (view.window?.frame.height)! - (frame?.height)!
        view.window?.setFrame(frame!, display: true, animate: true)
    }
    
    @IBAction func switchView(_ sender: Any) {
        switch mode {
        case .account, .none:
            switchCreateAccountView()
        case .createAccount:
            switchAccountView()
        }
        resizeWindow()
    }
}
