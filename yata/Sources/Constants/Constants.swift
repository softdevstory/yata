//
//  Constants.swift
//  yata
//
//  Created by HS Song on 2017. 6. 29..
//  Copyright © 2017년 HS Song. All rights reserved.
//

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
    case formatTitle = 401
    case formatHeader = 402
    case formatBody = 403
    case formatBlockQuote = 404
    case formatPullQuote = 405
    case formatBod = 406
    case formatItalic = 407
    case formatLink = 408
}
