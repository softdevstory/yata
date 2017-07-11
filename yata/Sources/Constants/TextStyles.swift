//
//  TextStyles.swift
//  yata
//
//  Created by HS Song on 2017. 7. 10..
//  Copyright © 2017년 HS Song. All rights reserved.
//

import Cocoa

struct ParagraphStyle {
    static let title: NSParagraphStyle = {
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineSpacing = 10
        
        return paragraph
    }()
    
    static let header: NSParagraphStyle = {
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineSpacing = 5
        
        return paragraph
    }()
    
    static let body: NSParagraphStyle = {
        let paragraph = NSMutableParagraphStyle()

        return paragraph
    }()
    
    static let singleQuotation: NSParagraphStyle = {
        let paragraph = NSMutableParagraphStyle()
        paragraph.firstLineHeadIndent = 10
        paragraph.headIndent = 10

        return paragraph
    }()
    
    static let doubleQuotation: NSParagraphStyle = {
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center
        
        return paragraph
    }()
}

enum TextStyles {

    case unknown
    case title
    case header
    case body
    case singleQuotation
    case doubleQuotation

    init(attributes: [String: Any]) {
        
        if TextStyles.isTitle(attributes: attributes) {
            self = .title
            return
        }
        
        if TextStyles.isHeader(attributes: attributes) {
            self = .header
            return
        }
        
        if TextStyles.isBody(attributes: attributes) {
            self = .body
            return
        }
        
        if TextStyles.isSingleQuotation(attributes: attributes) {
            self = .singleQuotation
            return
        }
        
        if TextStyles.isDoubleQuotation(attributes: attributes) {
            self = .doubleQuotation
            return
        }
        
        self = .unknown
    }
    
    var attributes: [String: Any] {
        switch self {
        case .title:
            return titleAttributes
        case .header:
            return headerAttributes
        case .body:
            return bodyAttributes
        case .singleQuotation:
            return singleQuotationAttributes
        case .doubleQuotation:
            return doubleQuotationAttributes
            
        case .unknown:
            Swift.print("Uknown Text Styles!!")
            return bodyAttributes
        }
    }
}

extension TextStyles {

    fileprivate var titleAttributes: [String: Any] {
        
        let font = NSFont.boldSystemFont(ofSize: NSFont.systemFontSize() + 6)
        
        return [
            NSFontAttributeName: font,
            NSParagraphStyleAttributeName: ParagraphStyle.title
        ]
    }
    
    fileprivate var headerAttributes: [String: Any] {

        let font = NSFont.boldSystemFont(ofSize: NSFont.systemFontSize() + 3)
        
        return [
            NSFontAttributeName: font,
            NSParagraphStyleAttributeName: ParagraphStyle.header
        ]
    }
    
    fileprivate var bodyAttributes: [String: Any] {

        let font = NSFont.systemFont(ofSize: NSFont.systemFontSize())
        
        return [
            NSFontAttributeName: font,
            NSParagraphStyleAttributeName: ParagraphStyle.body
        ]
    }
    
    fileprivate var singleQuotationAttributes: [String: Any] {
        
        let font = NSFontManager.shared().convert(NSFont.systemFont(ofSize: NSFont.systemFontSize()), toHaveTrait: .italicFontMask)
        
        return [
            NSFontAttributeName: font,
            NSParagraphStyleAttributeName: ParagraphStyle.singleQuotation
        ]
    }
    
    fileprivate var doubleQuotationAttributes: [String: Any] {

        let font = NSFontManager.shared().convert(NSFont.systemFont(ofSize: NSFont.systemFontSize()), toHaveTrait: .italicFontMask)
        
        return [
            NSFontAttributeName: font,
            NSParagraphStyleAttributeName: ParagraphStyle.doubleQuotation
        ]
    }

    fileprivate static func isTitle(attributes: [String: Any]) -> Bool {
        guard let paragraph = attributes[NSParagraphStyleAttributeName] as? NSParagraphStyle else {
            return false
        }
        
        guard let font = attributes[NSFontAttributeName] as? NSFont else {
            return false
        }
        
        if paragraph != ParagraphStyle.title {
            return false
        }
        
        if font.fontSize != NSFont.systemFontSize() + 6 {
            return false
        }
        
        return true
    }
    
    fileprivate static func isHeader(attributes: [String: Any]) -> Bool {
        guard let paragraph = attributes[NSParagraphStyleAttributeName] as? NSParagraphStyle else {
            return false
        }
        
        guard let font = attributes[NSFontAttributeName] as? NSFont else {
            return false
        }

        if paragraph != ParagraphStyle.header {
            return false
        }
        
        if font.fontSize != NSFont.systemFontSize() + 3 {
            return false
        }

        return true
    }

    fileprivate static func isBody(attributes: [String: Any]) -> Bool {
        guard let paragraph = attributes[NSParagraphStyleAttributeName] as? NSParagraphStyle else {
            return false
        }
        
        guard let font = attributes[NSFontAttributeName] as? NSFont else {
            return false
        }

        if paragraph != ParagraphStyle.body {
            return false
        }
        
        if font.fontSize != NSFont.systemFontSize() {
            return false
        }
        
        return true
    }

    fileprivate static func isSingleQuotation(attributes: [String: Any]) -> Bool {
        guard let paragraph = attributes[NSParagraphStyleAttributeName] as? NSParagraphStyle else {
            return false
        }
        
        guard let font = attributes[NSFontAttributeName] as? NSFont else {
            return false
        }

        if paragraph != ParagraphStyle.singleQuotation {
            return false
        }
        
        if font.fontSize != NSFont.systemFontSize() {
            return false
        }

        return true
    }

    fileprivate static func isDoubleQuotation(attributes: [String: Any]) -> Bool {
        guard let paragraph = attributes[NSParagraphStyleAttributeName] as? NSParagraphStyle else {
            return false
        }
        
        guard let font = attributes[NSFontAttributeName] as? NSFont else {
            return false
        }

        if paragraph != ParagraphStyle.doubleQuotation {
            return false
        }
        
        if font.fontSize != NSFont.systemFontSize() {
            return false
        }

        return true
    }
}

