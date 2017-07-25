//
//  TableRowView.swift
//  yata
//
//  Created by HS Song on 2017. 7. 20..
//  Copyright © 2017년 HS Song. All rights reserved.
//

import AppKit

class TableRowView: NSTableRowView {
    override func drawSeparator(in dirtyRect: NSRect) {
        var separatorRect = bounds
        separatorRect.origin.x = 8
        separatorRect.origin.y = NSMaxY(separatorRect) - 1
        separatorRect.size.height = 1
        separatorRect.size.width -= 8
        
        NSColor.gridColor.set()
        NSBezierPath.fill(separatorRect)
    }
}
