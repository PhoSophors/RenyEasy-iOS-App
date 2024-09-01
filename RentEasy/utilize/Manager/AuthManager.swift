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
    
    // Method to extract user ID from the token
  static func getUserIdFromToken() -> String? {
      guard let token = AuthManager.getToken() else {
          print("No token found")
          return nil
      }
      
      let parts = token.split(separator: ".")
      guard parts.count == 3 else {
          print("Invalid token format")
          return nil
      }
      
      let payloadBase64 = String(parts[1])
      print("Base64 payload: \(payloadBase64)")
      
      guard let payloadData = payloadBase64.base64Decoded() else {
          print("Failed to decode base64 payload")
          return nil
      }
      
      guard let payloadString = String(data: payloadData, encoding: .utf8) else {
          print("Failed to convert payload data to string")
          return nil
      }
      
      print("Decoded payload string: \(payloadString)")
      
     
      guard let payload = try? JSONSerialization.jsonObject(with: payloadData, options: []) as? [String: Any],
            let userId = payload["id"] as? String else {
          print("Failed to retrieve user ID from payload")
          return nil
      }
      
      return userId
  }

}

extension String {
    func base64Decoded() -> Data? {
        var base64 = self
        let paddingLength = (4 - (base64.count % 4)) % 4
        base64 += String(repeating: "=", count: paddingLength)
        return Data(base64Encoded: base64, options: [])
    }
}
