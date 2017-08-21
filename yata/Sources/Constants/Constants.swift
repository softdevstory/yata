//
//  Constants.swift
//  yata
//
//  Created by HS Song on 2017. 6. 29..
//  Copyright © 2017년 HS Song. All rights reserved.
//

import Foundation

struct FileName {
    static let acknowledgements = "acknowledgements"
    static let AcknowledgementsExtension = "html"
}

enum YataError: Swift.Error {
    case NoAccessToken
    case NoPagePath
    case InternalDataError
}

enum MenuTag: Int {
    case fileNewPage = 101
    case fileReload = 102
    case fileOpenInWebBrowser = 103
    
    case formatTitle = 401
    case formatHeader = 402
    case formatBody = 403
    case formatBlockQuote = 404
    case formatPullQuote = 405
    case formatBold = 406
    case formatItalic = 407
    case formatLink = 408
}

enum ToolbarTag: Int {
    case reloadPageList = 101
    case newPage = 102
    case textTool = 103
    case paragraphStyle = 104
    case viewInWebBrowser = 105
}

struct NotificationName {
    static let updatePageEditView = NSNotification.Name(rawValue: "updatePageEditView")
    static let contentModifiedState = NSNotification.Name(rawValue: "contentModifiedState")
}

