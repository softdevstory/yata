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
    private func convertJSONString(from jsonObject: [String: Any]) -> String? {
        let jsonData: NSData
        
        do {
            jsonData = try JSONSerialization.data(withJSONObject: jsonObject, options: JSONSerialization.WritingOptions()) as Data as NSData
            return String(data: jsonData as Data, encoding: String.Encoding.utf8)
        } catch _ {
            return nil
        }
    }
    func convertText() -> String {
        guard let textStorage = textStorage else {
            return ""
        }
        
        var json: Any?
        
        json = [[String: Any]]()
        
        for paragraph in textStorage.paragraphs {
            var range = NSMakeRange(0, paragraph.length)
            let attributes = paragraph.attributes(at: 0, effectiveRange: &range)
            let style = TextStyles(attributes: attributes)
            
            var element: [String: Any] = [:]
            switch style {
            case .unknown:
                element["tag"] = "p"
            case .title:
                element["tag"] = "h3"
            case .header:
                element["tag"] = "h4"
            case .body:
                element["tag"] = "p"
            case .singleQuotation:
                element["tag"] = "blockquote"
            case .doubleQuotation:
                element["tag"] = "aside"
            }
            element["children"] = [Any]()

            range = NSMakeRange(0, paragraph.length)
            paragraph.enumerateAttributes(in: range, options: []) { attrs, range, _ in
                let subStr = paragraph.attributedSubstring(from: range)
                
                var node: [String: Any] = [:]
                node["children"] = [subStr.string]
                
                if let font = attrs[NSFontAttributeName] as? NSFont {
                    if font.isBold {
                        switch style {
                        case .title, .header:
                            break
                        default:
                            var element: [String: Any] = [:]
                        
                            element["tag"] = "strong"
                            element["children"] = [node]
                            
                            node = element
                        }
                    }
                    
                    if font.isItalic {
                        switch style {
                        case .singleQuotation, .doubleQuotation:
                            break
                        default:
                            var element: [String: Any] = [:]
                            
                            element["tag"] = "em"
                            element["children"] = [node]
                            
                            node = element
                        }
                    }
                }
                
                if let _ = attrs[NSLinkAttributeName] as? String {
                    var element: [String: Any] = [:]
                    var attr: [String: Any] = [:]
                    
                    element["tag"] = "a"
                    element["children"] = [node]
                    attr["href"] = subStr.attribute(NSLinkAttributeName, at: 0, effectiveRange: nil) as? String
                    element["attrs"] = attr
                    
                    node = element
                }
                
                var array = element["children"] as! [Any]
                array.append(node)
                element["children"] = array
            }
            
            var array = json as! [[String: Any]]
            array.append(element)
            json = array as Any
        }
        
        do {
            let data = try JSONSerialization.data(withJSONObject: json!)
            let string = String(data: data, encoding: .utf8)
            return string ?? ""
        } catch {
            print("error \(error)")
        }
        
        return ""
    }
}


