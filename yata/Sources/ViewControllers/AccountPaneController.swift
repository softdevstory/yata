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
    let provider = RxMoyaProvider<TelegraphApi>()
    
    let viewModel = AccountPaneViewModel()
    
    fileprivate enum Mode {
        case none
        case account
        case createAccount
    }

    @IBOutlet var createAccountView: NSView!
    @IBOutlet weak var newShortNameField: NSTextField!
    @IBOutlet weak var newAuthorNameField: NSTextField!
    @IBOutlet weak var newAuthorUrlField: NSTextField!
    @IBOutlet weak var createAccountButton: NSButton!
    
    @IBOutlet var accountView: NSView!
    @IBOutlet weak var shortNameField: NSTextField!
    @IBOutlet weak var authorNameField: NSTextField!
    @IBOutlet weak var authorUrlField: NSTextField!
    @IBOutlet weak var modifyAccountButton: NSButton!
    @IBOutlet weak var revokeInternalTokenButton: NSButton!

    fileprivate var mode = Mode.none
    
    override var nibName: String? {
        return "AccountPane"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(createAccountView)
        setupCreateAccountView()
        
        view.addSubview(accountView)
        setupAccountView()
        
        if let accessToken = AccessTokenStorage.loadAccessToken() {
            // MARK: load account info
            switchAccountView()
        } else {
            switchCreateAccountView()
        }
    }
}

extension AccountPaneController {
    fileprivate func switchAccountView() {
        switch mode {
        case .account:
            break
        case .createAccount, .none:
            createAccountView.isHidden = true
            accountView.isHidden = false
            
            view.setFrameSize(accountView.frame.size)
            mode = .account

            resizeWindow()
            
            viewModel.getAccountInfo()
            .subscribe(onNext: nil, onError: { error in
                let alert = NSAlert(error: error)
                alert.beginSheetModal(for: self.view.window!, completionHandler: nil)
             }, onCompleted: {
                /* nothing */
            })
            .disposed(by: bag)
        }
    }
    
    fileprivate func switchCreateAccountView() {
        switch mode {
        case .account, .none:
            createAccountView.isHidden = false
            accountView.isHidden = true

            view.setFrameSize(createAccountView.frame.size)
            mode = .createAccount

            view.window?.makeFirstResponder(newShortNameField)
            
            resizeWindow()
        case .createAccount:
            break
        }
    }
    
    fileprivate func resizeWindow() {
        // resize window to fit to new view
        var frame = view.window?.frameRect(forContentRect: view.frame)
        frame?.origin = (view.window?.frame.origin)!
        frame?.origin.y += (view.window?.frame.height)! - (frame?.height)!
        view.window?.setFrame(frame!, display: true, animate: true)
    }
    
    fileprivate func setupCreateAccountView() {
          
        let observable = Observable.combineLatest(newShortNameField.rx.text, newAuthorNameField.rx.text, newAuthorUrlField.rx.text) {
            ($0, $1, $2)
        }
        
        createAccountButton.rx.tap.withLatestFrom(observable)
            .filter { (shortName, _, _) -> Bool in
                if shortName?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) == "" {
                
                    alertSheetModal(for: self.view.window!, message: "Short name is required.".localized, information: "Short name can not be empty. Please input short name.".localized)
                    
                    return false
                }
                
                return true
            }
            .map { ($0!, $1, $2) }
            .subscribe(onNext: { (shortName, authorName, authorUrl) in
            
                self.viewModel.createAccount(shortName: shortName, authorName: authorName, authorUrl: authorUrl)
                    .observeOn(MainScheduler.instance)
                    .subscribe(onNext: nil, onError: { error in
                        let alert = NSAlert(error: error)
                        alert.beginSheetModal(for: self.view.window!, completionHandler: nil)
                    }, onCompleted: {
                        self.switchAccountView()
                    })
                    .disposed(by: self.bag)
                
            })
            .addDisposableTo(bag)
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
        
    }
}
