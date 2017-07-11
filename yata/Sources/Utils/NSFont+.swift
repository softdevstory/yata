//
//  NSFont+.swift
//  yata
//
//  Created by HS Song on 2017. 7. 11..
//  Copyright © 2017년 HS Song. All rights reserved.
//

import Cocoa

extension NSFont {

    var fontSize: CGFloat? {
        return fontDescriptor.object(forKey: NSFontSizeAttribute) as? CGFloat
    }
    
    var isBold: Bool {
        return fontDescriptor.symbolicTraits & NSFontSymbolicTraits(NSFontBoldTrait) != 0
    }
    
    var isItalic: Bool {
        return fontDescriptor.symbolicTraits & NSFontSymbolicTraits(NSFontItalicTrait) != 0
    }
}
