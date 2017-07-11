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
        
        typingAttributes = TextStyles.body.attributes
    }
    
    func resetText() {
        string = ""
        
        typingAttributes = TextStyles.body.attributes
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
        changeParagraphStyle(style: TextStyles.title.attributes)
    }
    
    func setHeaderStyle() {
        changeParagraphStyle(style: TextStyles.header.attributes)
    }
    
    func setBodyStyle() {
        changeParagraphStyle(style: TextStyles.body.attributes)
    }
    
    func setSingleQuotationStyle() {
        changeParagraphStyle(style: TextStyles.singleQuotation.attributes)
    }
    
    func setDoubleQuotationStyle() {
        changeParagraphStyle(style: TextStyles.doubleQuotation.attributes)
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

// MARK: Converting

extension EditorView {
    func convertText() {
        guard let textStorage = textStorage else {
            return
        }
        
        var nodes: [Node] = []
        
        for paragraph in textStorage.paragraphs {
            var range = NSMakeRange(0, paragraph.length)
            let attributes = paragraph.attributes(at: 0, effectiveRange: &range)
            let style = TextStyles(attributes: attributes)
            
            let element = NodeElement()
            switch style {
            case .unknown:
                element.tag = "p"
            case .title:
                element.tag = "h3"
            case .header:
                element.tag = "h4"
            case .body:
                element.tag = "p"
            case .singleQuotation:
                element.tag = "blockquote"
            case .doubleQuotation:
                element.tag = "aside"
            }
            element.children = []

            range = NSMakeRange(0, paragraph.length)
            paragraph.enumerateAttributes(in: range, options: []) { attrs, range, _ in
                let subStr = paragraph.attributedSubstring(from: range)
                
                var node = Node(string: subStr.string)
                
                if let font = attrs[NSFontAttributeName] as? NSFont {
                    if font.isBold {
                        switch style {
                        case .title, .header:
                            break
                        default:
                            let element = NodeElement()
                        
                            element.tag = "strong"
                            element.children = []
                            element.children?.append(node)
                            
                            node = Node(element: element)
                        }
                    }
                    
                    if font.isItalic {
                        switch style {
                        case .singleQuotation, .doubleQuotation:
                            break
                        default:
                            let element = NodeElement()
                            
                            element.tag = "em"
                            element.children = []
                            element.children?.append(node)
                            
                            node = Node(element: element)
                        }
                    }
                }
                
                if let _ = attrs[NSLinkAttributeName] as? String {
                    let element = NodeElement()

                    element.tag = "a"
                    element.children = []
                    element.children?.append(node)
                    element.attrs = Attrs()
                    element.attrs?.href = subStr.attribute(NSLinkAttributeName, at: 0, effectiveRange: nil) as? String
                    
                    node = Node(element: element)
                }
                
                element.children?.append(node)
            }
            
//            Swift.print(element.toJSONString()!)
            nodes.append(Node(element: element))
        }
    }
}


