//
//  AccessTokenStorage.swift
//  yata
//
//  Created by HS Song on 2017. 6. 29..
//  Copyright © 2017년 HS Song. All rights reserved.
//

import Foundation
import KeychainAccess

class AccessTokenStorage {
    
    private static func getKeychain() -> Keychain {
        return Keychain(service: KeyChain.service, accessGroup: KeyChain.accessGroup).synchronizable(true)
    }
    
    static func loadAccessToken() -> String? {
        let keychain = getKeychain()

        return keychain[KeyChain.keyForAccessToken]
    }
    
    static func saveAccessToken(_ token: String) {
    
        let keychain = getKeychain()
        
        keychain[KeyChain.keyForAccessToken] = token
    }
    
    static func deleteAccessToken() {
        let keychain = getKeychain()
    
        keychain[KeyChain.keyForAccessToken] = nil
    }
}
