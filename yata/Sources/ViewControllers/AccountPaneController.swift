//
//  AccountPaneController.swift
//  yata
//
//  Created by HS Song on 2017. 6. 28..
//  Copyright © 2017년 HS Song. All rights reserved.
//

import Cocoa

import RxSwift
import RxCocoa
import Moya

class AccountPaneController: NSViewController {

    let bag = DisposeBag()
    
    let viewModel = AccountPaneViewModel()
    
    @IBOutlet var accountView: NSView!
    @IBOutlet weak var shortNameField: NSTextField!
    @IBOutlet weak var authorNameField: NSTextField!
    @IBOutlet weak var authorUrlField: NSTextField!
    @IBOutlet weak var modifyAccountButton: NSButton!
    @IBOutlet weak var revokeInternalTokenButton: NSButton!

    @IBOutlet weak var noAccountLabel: NSTextField!
    
    override var nibName: String? {
        return "AccountPane"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(accountView)
        setupAccountView()
                
        view.setFrameSize(accountView.frame.size)
        resizeWindow()

        viewModel.getAccountInfo()
            .subscribe(onNext: nil, onError: { error in
                self.switchNoAccountView()
            }, onCompleted: {
                self.switchAccountView()
            })
            .disposed(by: bag)
    }
}

extension AccountPaneController {
    private func disableComponents() {
        shortNameField.isEnabled = false
        authorNameField.isEnabled = false
        authorUrlField.isEnabled = false
        modifyAccountButton.isEnabled = false
        revokeInternalTokenButton.isEnabled = false
    }
    
    fileprivate func switchNoAccountView() {
        noAccountLabel.isHidden = false
        accountView.isHidden = true
    }
    
    fileprivate func switchAccountView() {

        noAccountLabel.isHidden = true
        accountView.isHidden = false
    }
    
    fileprivate func resizeWindow() {
        // resize window to fit to new view
        var frame = view.window?.frameRect(forContentRect: view.frame)
        frame?.origin = (view.window?.frame.origin)!
        frame?.origin.y += (view.window?.frame.height)! - (frame?.height)!
        view.window?.setFrame(frame!, display: true, animate: true)
    }
    
    fileprivate func setupAccountView() {

        viewModel.shortName
            .asObservable()
            .bind(to: shortNameField.rx.text)
            .disposed(by: bag)
        
        viewModel.authorName
            .asObservable()
            .bind(to: authorNameField.rx.text)
            .disposed(by: bag)
        
        viewModel.authorUrl
            .asObservable()
            .bind(to: authorUrlField.rx.text)
            .disposed(by: bag)
        
        modifyAccountButton.rx.tap
            .map { (self.shortNameField.stringValue, self.authorNameField.stringValue, self.authorUrlField.stringValue) }
            .filter { (shortName, _, _) -> Bool in
                if shortName.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) == "" {
                
                    alertSheetModal(for: self.view.window!, message: "Short name is required.".localized, information: "Short name can not be empty. Please input short name.".localized)
                    
                    return false
                }
                
                return true
            }
            .subscribe(onNext: { (shortName, authorName, authorUrl) in
            
                self.viewModel.editAccountInfo(shortName: shortName, authorName: authorName, authorUrl: authorUrl)
                    .observeOn(MainScheduler.instance)
                    .subscribe(onNext: nil, onError: { error in
                        let alert = NSAlert(error: error)
                        alert.beginSheetModal(for: self.view.window!, completionHandler: nil)
                    }, onCompleted: {
                        let alert = NSAlert()
                        alert.alertStyle = .informational
                        alert.messageText = "Account Modification is done.".localized
                        alert.beginSheetModal(for: self.view.window!, completionHandler: nil)
                    })
                    .disposed(by: self.bag)
                
            })
            .disposed(by: bag)
     
        revokeInternalTokenButton.rx.tap
            .subscribe(onNext: {
                self.viewModel.revokeAccessToken()
                    .observeOn(MainScheduler.instance)
                    .subscribe(onNext: nil, onError: { error in
                        let alert = NSAlert(error: error)
                        alert.beginSheetModal(for: self.view.window!, completionHandler: nil)
                    }, onCompleted: {
                        let alert = NSAlert()
                        alert.alertStyle = .informational
                        alert.messageText = "Revoking Internal Token is done.".localized
                        alert.beginSheetModal(for: self.view.window!, completionHandler: nil)
                    })
                    .disposed(by: self.bag)
            })
            .disposed(by: bag)
    }
}
