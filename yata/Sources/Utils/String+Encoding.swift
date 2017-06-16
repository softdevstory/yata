//
//  String+Encoding.swift
//  yata
//
//  Created by HS Song on 2017. 6. 15..
//  Copyright © 2017년 HS Song. All rights reserved.
//

import Foundation

extension String {
    var urlEscaped: String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }

    var utf8Encoded: Data {
        return self.data(using: .utf8)!
    }
}
