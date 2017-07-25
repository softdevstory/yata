//
//  TableView.swift
//  yata
//
//  Created by HS Song on 2017. 7. 25..
//  Copyright © 2017년 HS Song. All rights reserved.
//

import AppKit

class TableView: NSTableView {

    func yPositionPastLastRow() -> CGFloat {
        var yStart: CGFloat = 0
        if numberOfRows > 0 {
            yStart = NSMaxY(rect(ofRow: numberOfRows - 1))
        }
        return yStart
    }
    
    func drawSeparator(in dirtyRect: NSRect) {
        var separatorRect = bounds
        separatorRect.origin.x = 8
        separatorRect.origin.y = NSMaxY(separatorRect) - 1
        separatorRect.size.height = 1
        separatorRect.size.width -= 8
        
        NSColor.gridColor.set()
        NSBezierPath.fill(separatorRect)
    }
    
    override func drawGrid(inClipRect clipRect: NSRect) {
        var yStart = yPositionPastLastRow()
        yStart += rowHeight
        
        let boundsToDraw = bounds
        var seperatorRect = boundsToDraw
        while yStart < NSMaxY(boundsToDraw) {
            seperatorRect.origin.y = yStart
            drawSeparator(in: seperatorRect)
            yStart += rowHeight
        }
    }
}
