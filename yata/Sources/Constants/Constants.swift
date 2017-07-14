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
