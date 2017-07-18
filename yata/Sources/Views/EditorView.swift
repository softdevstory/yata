//
//  EditorView.swift
//  yata
//
//  Created by HS Song on 2017. 7. 6..
//  Copyright © 2017년 HS Song. All rights reserved.
//

import Cocoa

class EditorView: NSTextView {
    override func viewDidMoveToWindow() {
        super.viewDidMoveToWindow()
        
        delegate = self
        
        resetText()
    }
    
    func resetText() {
        string = ""

        font = NSFont.systemFont(ofSize: NSFont.systemFontSize())
        typingAttributes = TextStyles.body.attributes
    }

    // Prevent paste unkown styles
    override func paste(_ sender: Any?) {
        super.pasteAsPlainText(sender)
    }
}

// MARK: style
extension EditorView {

    private func isBoldFont(range: NSRange) -> Bool {
        if let fontAttr = textStorage?.fontAttributes(in: range),
            let font = fontAttr[NSFontAttributeName] as? NSFont {
            return font.isBold
        }

        return false
    }

    private func isItalicFont(range: NSRange) -> Bool {
        if let fontAttr = textStorage?.fontAttributes(in: range),
            let font = fontAttr[NSFontAttributeName] as? NSFont {
            return font.isItalic
        }

        // ??
        return false
    }
    
    func isBold() -> Bool {
        guard let textStorage = textStorage, textStorage.length > 0 else {
            return false
        }
        
        let range = selectedRange()

        return isBoldFont(range: range)
    }
    
    func isItalic() -> Bool {
        guard let textStorage = textStorage, textStorage.length > 0 else {
            return false
        }

        let range = selectedRange()

        return isItalicFont(range: range)
    }
    
    func toggleBoldStyle() {
        changeSelectedStyle() { (storage, range) in
            if isBoldFont(range: range) {
                storage.applyFontTraits(.unboldFontMask, range: range)
            } else {
                storage.applyFontTraits(.boldFontMask, range: range)
            }
        }
    }
    
    func toggleItalicStyle() {
        changeSelectedStyle() { (storage, range) in
            if isItalicFont(range: range) {
                storage.applyFontTraits(.unitalicFontMask, range: range)
            } else {
                storage.applyFontTraits(.italicFontMask, range: range)
            }
        }
    }
    
    func setLink(link: String) {
        changeSelectedStyle() { (storage, range) in
            storage.addAttribute(NSLinkAttributeName, value: link, range: range)
        }
    }
    
    func deleteLink() {
        changeSelectedStyle() { (storage, range) in
            storage.removeAttribute(NSLinkAttributeName, range: range)
        }
    }
    
    func getCurrentLink() -> String? {
        guard let textStorage = textStorage, textStorage.length > 0 else {
            return nil
        }

        var range = selectedRange()
        
        return textStorage.attribute(NSLinkAttributeName, at: range.location, effectiveRange: &range) as? String
    }
    
    func setTitleStyle() {
        changeParagraphStyle(style: TextStyles.title.attributes)
    }
    
    func setHeaderStyle() {
        changeParagraphStyle(style: TextStyles.header.attributes)
    }
    
    func setBodyStyle() {
        changeParagraphStyle(style: TextStyles.body.attributes)
    }
    
    func setBlockQuoteStyle() {
        changeParagraphStyle(style: TextStyles.blockQuote.attributes)
    }
    
    func setPullQuoteStyle() {
        changeParagraphStyle(style: TextStyles.pullQuote.attributes)
    }
    
    func currentParagraphStyle() -> TextStyles {
        guard let storage = textStorage else {
            return TextStyles.unknown
        }
        
        let range = selectedRange()

        let nsString = storage.string as NSString?
        if var paragraphRange = nsString?.paragraphRange(for: range) {

            if paragraphRange.length == 0 {
                return TextStyles.unknown
            }
            
            let attrs = storage.attributes(at: paragraphRange.location, effectiveRange: &paragraphRange)
            return TextStyles(attributes: attrs)
        }

        return TextStyles.unknown
    }
    
}


// MARK: support redo / undo
extension EditorView {

    fileprivate func changeSelectedStyle(work: (_ storage: NSTextStorage, _ range: NSRange) -> Void) {
        guard let storage = textStorage else {
            return
        }

        let range = selectedRange()
        
        if shouldChangeText(in: range, replacementString: nil) {
            storage.beginEditing()
            
            work(storage, range)
            
            storage.endEditing()
            didChangeText()
        }
    }
    
    fileprivate func changeParagraphStyle(style: [String: Any]) {
        guard let storage = textStorage else {
            return
        }

        let range = selectedRange()
        
        let nsString = storage.string as NSString?
        if let paragraphRange = nsString?.paragraphRange(for: range) {
        
            if shouldChangeText(in: paragraphRange, replacementString: nil) {
                storage.beginEditing()
                
                storage.setAttributes(style, range: paragraphRange)
                
                storage.endEditing()
                didChangeText()
            }
        }
    }
}

extension EditorView: NSTextViewDelegate {
    func textViewDidChangeSelection(_ notification: Notification) {
        let paragraphStyle = currentParagraphStyle()
        switch paragraphStyle {
        case .unknown:
            Swift.print("unkonwn")
        case .title:
            Swift.print("title")
        case .header:
            Swift.print("header")
        case .body:
            Swift.print("body")
        case .blockQuote:
            Swift.print("blockquote")
        case .pullQuote:
            Swift.print("pullQuote")
        }
    }
}
