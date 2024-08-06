//
//  NetworkConstants.swift
//  RentEasy
//
//  Created by Apple on 5/8/24.
//

import Foundation

class NetworkConstants {
    
    public static var shared: NetworkConstants = NetworkConstants()
    let MainAPI = "http://localhost:3000"
    
    public var serverAddress: String {
        return MainAPI
    }
    
    class Endpoints {
        // MARK: Auth Endpoint
       public static var login: String {
           return "\(NetworkConstants.shared.serverAddress)/auths/login"
       }
       public static var register: String {
           return "\(NetworkConstants.shared.serverAddress)/auths/register"
       }
       public static var registerVerifyOTP: String {
           return "\(NetworkConstants.shared.serverAddress)/auths/register-verify"
       }
        
        // MARK: User
        public static var getUserInfo: String {
            return "\(NetworkConstants.shared.serverAddress)/auths/profile"
        }
        public static var updateUserInfo: String {
            return "\(NetworkConstants.shared.serverAddress)/auth/update-profile"
        }
        
        
      
   }
}
