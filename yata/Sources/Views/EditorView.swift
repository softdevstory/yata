//
//  EditorView.swift
//  yata
//
//  Created by HS Song on 2017. 7. 6..
//  Copyright © 2017년 HS Song. All rights reserved.
//

import Cocoa

class EditorView: NSTextView {
    
}

extension EditorView {
    private func isBoldFont(range: NSRange) -> Bool {
        if let fontAttr = textStorage?.fontAttributes(in: range),
            let font = fontAttr[NSFontAttributeName] as? NSFont {
            
            let traits = NSFontManager.shared().traits(of: font)
            return traits.contains(.boldFontMask)
        }

        // ??
        return false
    }

    private func isItalicFont(range: NSRange) -> Bool {
        if let fontAttr = textStorage?.fontAttributes(in: range),
            let font = fontAttr[NSFontAttributeName] as? NSFont {
            
            let traits = NSFontManager.shared().traits(of: font)
            return traits.contains(.italicFontMask)
        }

        // ??
        return false
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
        var range = selectedRange()
        
        return textStorage?.attribute(NSLinkAttributeName, at: range.location, effectiveRange: &range) as? String
    }
    
    
    func setTitleStyle() {
        changeParagraphStyle() { (storage, range) in
            let font = NSFont.boldSystemFont(ofSize: NSFont.systemFontSize() + 6)
            storage.setAttributes([NSFontAttributeName: font], range: range)
        }
    }
    
    func setHeaderStyle() {
        changeParagraphStyle() { (storage, range) in
            let font = NSFont.boldSystemFont(ofSize: NSFont.systemFontSize() + 3)
            storage.setAttributes([NSFontAttributeName: font], range: range)
        }
    }
    
    func setBodyStyle() {
        changeParagraphStyle() { (storage, range) in
            let font = NSFont.systemFont(ofSize: NSFont.systemFontSize())
            storage.setAttributes([NSFontAttributeName: font], range: range)
        }
    }
    
    func setSingleQuotationStyle() {
        changeParagraphStyle() { (storage, range) in
            let font = NSFont.systemFont(ofSize: NSFont.systemFontSize())
            let italicFont = NSFontManager.shared().convert(font, toHaveTrait: .italicFontMask)

            storage.setAttributes([NSFontAttributeName: italicFont], range: range)
        }
    }
    
    func setDoubleQuotationStyle() {
        changeParagraphStyle() { (storage, range) in
            let paragraph = NSMutableParagraphStyle()
            paragraph.alignment = .center
            
            let font = NSFont.systemFont(ofSize: NSFont.systemFontSize())
            let italicFont = NSFontManager.shared().convert(font, toHaveTrait: .italicFontMask)

            storage.setAttributes([
                NSFontAttributeName: italicFont,
                NSParagraphStyleAttributeName: paragraph
                ], range: range)
        }
    }
    
    override func paste(_ sender: Any?) {
        super.pasteAsPlainText(sender)
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
    
    fileprivate func changeParagraphStyle(work: (_ storage: NSTextStorage, _ range: NSRange) -> Void) {
        guard let storage = textStorage else {
            return
        }

        let range = selectedRange()
        
        let nsString = storage.string as NSString?
        if let paragraphRange = nsString?.paragraphRange(for: range) {
        
            if shouldChangeText(in: paragraphRange, replacementString: nil) {
                storage.beginEditing()
                
                work(storage, range)
                
                storage.endEditing()
                didChangeText()
            }
        }
    }

}


