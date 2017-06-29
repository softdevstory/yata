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
    
    private func getKeychain() -> Keychain {
        return Keychain(service: KeyChain.service, accessGroup: KeyChain.accessGroup).synchronizable(true)
    }
    
    func loadAccessToken() -> String? {
        let keychain = getKeychain()

        return keychain[KeyChain.keyForAccessToken]
    }
    
    func saveAccessToken(_ token: String) {
    
        let keychain = getKeychain()
        
        keychain[KeyChain.keyForAccessToken] = token
    }
    
    func deleteAccessToken() {
        let keychain = getKeychain()
    
        keychain[KeyChain.keyForAccessToken] = nil
    }
}
