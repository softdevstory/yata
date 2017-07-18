//
//  TextStylePopoverViewController.swift
//  yata
//
//  Created by HS Song on 2017. 7. 7..
//  Copyright © 2017년 HS Song. All rights reserved.
//

import AppKit

import RxSwift
import RxCocoa

enum TextStylePopoverResult {
    case none
    case titleStyle
    case headerStyle
    case bodyStyle
    case blockQuotationStyle
    case pullQuoteStyle
}

class TextStylePopoverViewController: NSViewController {

    @IBOutlet weak var stackView: NSStackView!
    
    private var titleButton: PopoverButton!
    private var headerButton: PopoverButton!
    private var bodyButton: PopoverButton!
    private var blockQuoteButton: PopoverButton!
    private var pullQuoteButton: PopoverButton!

    private let bag = DisposeBag()

    // MARK: Input
    var textStyle = Variable<TextStyles>(.body)

    // MARK: Output
    var result = Variable<TextStylePopoverResult>(.none)

    override var nibName: String? {
        return "TextStylePopover"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
     
        configure()
    }
    
    private func configure() {
        var attrStr = NSAttributedString(string: "Title".localized, attributes: TextStyles.title.attributes)
        titleButton = PopoverButton(attributedString: attrStr)
        stackView.addArrangedSubview(titleButton)
        titleButton.snp.makeConstraints { maker in
            maker.leading.equalToSuperview()
            maker.trailing.equalToSuperview()
        }
        titleButton.isChecked = false
        titleButton.tap
            .subscribe(onNext: {
                self.result.value = .titleStyle
            })
            .disposed(by: bag)

        attrStr = NSAttributedString(string: "Header".localized, attributes: TextStyles.header.attributes)
        headerButton = PopoverButton(attributedString: attrStr)
        stackView.addArrangedSubview(headerButton)
        headerButton.snp.makeConstraints { maker in
            maker.leading.equalToSuperview()
            maker.trailing.equalToSuperview()
        }
        headerButton.tap
            .subscribe(onNext: {
                self.result.value = .headerStyle
            })
            .disposed(by: bag)

        attrStr = NSAttributedString(string: "Body".localized, attributes: TextStyles.body.attributes)
        bodyButton = PopoverButton(attributedString: attrStr)
        stackView.addArrangedSubview(bodyButton)
        bodyButton.snp.makeConstraints { maker in
            maker.leading.equalToSuperview()
            maker.trailing.equalToSuperview()
        }
        bodyButton.tap
            .subscribe(onNext: {
                self.result.value = .bodyStyle
            })
            .disposed(by: bag)

        attrStr = NSAttributedString(string: "Block Quote".localized, attributes: TextStyles.blockQuote.attributes)
        blockQuoteButton = PopoverButton(attributedString: attrStr)
        stackView.addArrangedSubview(blockQuoteButton)
        blockQuoteButton.snp.makeConstraints { maker in
            maker.leading.equalToSuperview()
            maker.trailing.equalToSuperview()
        }
        blockQuoteButton.tap
            .subscribe(onNext: {
                self.result.value = .blockQuotationStyle
            })
            .disposed(by: bag)

        attrStr = NSAttributedString(string: "Pull Quote".localized, attributes: TextStyles.pullQuote.attributes)
        pullQuoteButton = PopoverButton(attributedString: attrStr)
        stackView.addArrangedSubview(pullQuoteButton)
        pullQuoteButton.snp.makeConstraints { maker in
            maker.leading.equalToSuperview()
            maker.trailing.equalToSuperview()
        }
        pullQuoteButton.tap
            .subscribe(onNext: {
                self.result.value = .pullQuoteStyle
            })
            .disposed(by: bag)

        textStyle.asObservable()
            .subscribe(onNext: { style in
            
                self.titleButton.isChecked = false
                self.headerButton.isChecked = false
                self.bodyButton.isChecked = false
                self.blockQuoteButton.isChecked = false
                self.pullQuoteButton.isChecked = false
                
                switch style {
                case .title:
                    self.titleButton.isChecked = true
                case .header:
                    self.headerButton.isChecked = true
                case .body, .unknown:
                    self.bodyButton.isChecked = true
                case .blockQuote:
                    self.blockQuoteButton.isChecked = true
                case .pullQuote:
                    self.pullQuoteButton.isChecked = true
                }
            })
            .disposed(by: bag)
    }
}
