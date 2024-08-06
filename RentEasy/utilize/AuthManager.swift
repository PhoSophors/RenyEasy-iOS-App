//
//  AuthManager.swift
//  RentEasy
//
//  Created by Apple on 5/8/24.
//

import Foundation

class AuthManager {
    private static let accessTokenKey = "accessToken"
    
    static func saveToken(_ token: String) {
        UserDefaults.standard.set(token, forKey: accessTokenKey)
        print("save accesss token: \(token)")
    }
    
    static func getToken() -> String? {
        return UserDefaults.standard.string(forKey: accessTokenKey)
        print("Get token: \(accessTokenKey)")
    }
    
    static func isLoggedIn() -> Bool {
        return getToken() != nil
    }
    
    static func clearToken() {
        UserDefaults.standard.removeObject(forKey: accessTokenKey)
    }
}
