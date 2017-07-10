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
        let range = selectedRange()
        
        if isBoldFont(range: range) {
            textStorage?.applyFontTraits(.unboldFontMask, range: range)
        } else {
            textStorage?.applyFontTraits(.boldFontMask, range: range)
        }
    }
    
    func toggleItalicStyle() {
        let range = selectedRange()
        
        if isItalicFont(range: range) {
            textStorage?.applyFontTraits(.unitalicFontMask, range: range)
        } else {
            textStorage?.applyFontTraits(.italicFontMask, range: range)
        }
    }
    
    func setLink(link: String) {
        let range = selectedRange()
        
        textStorage?.addAttribute(NSLinkAttributeName, value: link, range: range)
    }
    
    func deleteLink() {
        let range = selectedRange()
        
        textStorage?.removeAttribute(NSLinkAttributeName, range: range)
    }
    
    func getCurrentLink() -> String? {
        var range = selectedRange()
        
        return textStorage?.attribute(NSLinkAttributeName, at: range.location, effectiveRange: &range) as? String
    }
}
