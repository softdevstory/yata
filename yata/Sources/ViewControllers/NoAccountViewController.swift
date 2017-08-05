//
//  NoAccountViewController.swift
//  yata
//
//  Created by HS Song on 2017. 7. 25..
//  Copyright © 2017년 HS Song. All rights reserved.
//

import AppKit

import RxSwift
import RxCocoa

class NoAccountViewController: NSViewController {
    
    @IBOutlet weak var shortNameTextField: NSTextField!
    @IBOutlet weak var authorNameTextField: NSTextField!
    @IBOutlet weak var profileLinkTextField: NSTextField!
    
    @IBOutlet weak var createAccountButton: NSButton!
    
    let bag = DisposeBag()
    
    let viewModel = NoAccountViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
    }

    private func configure() {
          
        let observable = Observable.combineLatest(shortNameTextField.rx.text, authorNameTextField.rx.text, profileLinkTextField.rx.text) {
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
//                        self.switchAccountView()

                    })
                    .disposed(by: self.bag)
                
            })
            .addDisposableTo(bag)
    }

}
