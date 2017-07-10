//
//  TextStyles.swift
//  yata
//
//  Created by HS Song on 2017. 7. 10..
//  Copyright © 2017년 HS Song. All rights reserved.
//

import Cocoa

struct TextStyles {
    
    static let title: [String: Any] = {
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineSpacing = 10
        
        let font = NSFont.boldSystemFont(ofSize: NSFont.systemFontSize() + 6)

        return [
            NSFontAttributeName: font,
            NSParagraphStyleAttributeName: paragraph
        ]
    }()
    
    static let header: [String: Any] = {
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineSpacing = 5
        
        let font = NSFont.boldSystemFont(ofSize: NSFont.systemFontSize() + 3)

        return [
            NSFontAttributeName: font,
            NSParagraphStyleAttributeName: paragraph
        ]
    }()
    
    static let body: [String: Any] = {
        let paragraph = NSMutableParagraphStyle()
        
        let font = NSFont.systemFont(ofSize: NSFont.systemFontSize())

        return [
            NSFontAttributeName: font,
            NSParagraphStyleAttributeName: paragraph
        ]
    }()
    
    static let singleQuotation: [String: Any] = {
        let paragraph = NSMutableParagraphStyle()
        
        let font = NSFontManager.shared().convert(NSFont.systemFont(ofSize: NSFont.systemFontSize()), toHaveTrait: .italicFontMask)

        return [
            NSFontAttributeName: font,
            NSParagraphStyleAttributeName: paragraph
        ]
    }()
    
    static let doubleQuotation: [String: Any] = {
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center

        let font = NSFontManager.shared().convert(NSFont.systemFont(ofSize: NSFont.systemFontSize()), toHaveTrait: .italicFontMask)

        return [
            NSFontAttributeName: font,
            NSParagraphStyleAttributeName: paragraph
        ]
    }()
}

