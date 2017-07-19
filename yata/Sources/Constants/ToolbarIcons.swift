//
//  ToolbarIcons.swift
//  yata
//
//  Created by HS Song on 2017. 7. 19..
//  Copyright © 2017년 HS Song. All rights reserved.
//

import Foundation

import Then

struct ToolbarIcons {
    static let reload: NSImage = {
        return #imageLiteral(resourceName: "icons8-synchronize").then {
            $0.size = NSMakeSize(16, 16)
        }
    }()
    
    static let newPage: NSImage = {
        return #imageLiteral(resourceName: "icons8-create_new").then {
            $0.size = NSMakeSize(16, 16)
        }
    }()
    
    static let bold: NSImage = {
        return #imageLiteral(resourceName: "icons8-bold").then {
            $0.size = NSMakeSize(16, 16)
        }
    }()
    
    static let boldChecked: NSImage = {
        return #imageLiteral(resourceName: "icons8-bold_filled").then {
            $0.size = NSMakeSize(16, 16)
        }
    }()
    
    static let italic: NSImage = {
        return #imageLiteral(resourceName: "icons8-italic").then {
            $0.size = NSMakeSize(16, 16)
        }
    }()

    static let italicChecked: NSImage = {
        return #imageLiteral(resourceName: "icons8-italic_filled").then {
            $0.size = NSMakeSize(16, 16)
        }
    }()
    
    static let link: NSImage = {
        return #imageLiteral(resourceName: "icons8-link").then {
            $0.size = NSMakeSize(16, 16)
        }
    }()

    static let linkChecked: NSImage = {
        return #imageLiteral(resourceName: "icons8-link_filled").then {
            $0.size = NSMakeSize(16, 16)
        }
    }()
    
    static let paragraphStyle: NSImage = {
        return #imageLiteral(resourceName: "icons8-lowercase").then {
            $0.size = NSMakeSize(16, 16)
        }
    }()
    
    static let webBrowser: NSImage = {
        return #imageLiteral(resourceName: "icons8-internet").then {
            $0.size = NSMakeSize(16, 16)
        }
    }()
}
