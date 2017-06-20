//
//  Bundle+.swift
//  yata
//
//  Created by HS Song on 2017. 6. 20..
//  Copyright © 2017년 HS Song. All rights reserved.
//

import Foundation

extension Bundle {
    var bundleName: String {
        if let name = localizedInfoDictionary?[(kCFBundleNameKey as String)] as? String {
            return name
        }
        
        return "YATA".localized
    }
}
