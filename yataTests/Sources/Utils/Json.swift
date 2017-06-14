//
//  Json.swift
//  yata
//
//  Created by HS Song on 2017. 6. 14..
//  Copyright © 2017년 HS Song. All rights reserved.
//

import Foundation

func convertJSONString(from jsonObject: [String: Any]) -> String? {
    let jsonData: NSData
    
    do {
        jsonData = try JSONSerialization.data(withJSONObject: jsonObject, options: JSONSerialization.WritingOptions()) as Data as NSData
        return String(data: jsonData as Data, encoding: String.Encoding.utf8)
    } catch _ {
        return nil
    }
}
