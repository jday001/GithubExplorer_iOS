//
//  User.swift
//  GithubExplorer_iOS
//
//  Created by Day, Jeff @ Dallas on 10/29/18.
//  Copyright © 2018 Day, Jeff @ Dallas. All rights reserved.
//

import Foundation


struct Credentials {
    let username: String
    let password: String
    
    var encoded: String {
        let encodedString = Data((username + ":" + password).utf8).base64EncodedString()
        return encodedString
    }
}


struct User: Codable {
    let id: Int
    let username: String
    let name: String
    let avatarURL: URL
    var authCredentials: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case username = "login"
        case name
        case avatarURL = "avatar_url"
        case authCredentials
    }
    
    func saveToKeychain() {
        guard let userData = try? JSONEncoder().encode(self) else {
            return
        }
        
        let keychain = KeychainSwift()
        keychain.set(userData.base64EncodedData(), forKey: KeychainKeys.userData.rawValue)
    }
}
