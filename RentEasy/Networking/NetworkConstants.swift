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
        // MARK: - Auth Endpoint
       public static var login: String {
           return "\(NetworkConstants.shared.serverAddress)/auths/login"
       }
       public static var register: String {
           return "\(NetworkConstants.shared.serverAddress)/auths/register"
       }
       public static var registerVerifyOTP: String {
           return "\(NetworkConstants.shared.serverAddress)/auths/register-verify"
       }
        public static var forgotPassword: String {
            return "\(NetworkConstants.shared.serverAddress)/auths/request-reset-password"
        }
        public static var verifyResetPasswordOTP: String {
            return "\(NetworkConstants.shared.serverAddress)/auths/verify-reset-password-otp"
        }
        public static var setNewPassword: String {
            return "\(NetworkConstants.shared.serverAddress)/auths/set-new-password"
        }
        
        
        // MARK: - User
        public static var getUserInfo: String {
            return "\(NetworkConstants.shared.serverAddress)/auths/profile"
        }
        public static var updateUserInfo: String {
            return "\(NetworkConstants.shared.serverAddress)/auths/update-profile"
        }
        public static var getAllUser: String {
            return "\(NetworkConstants.shared.serverAddress)/admin/all-users"
        }
      
        // MARK: - Favorites
        public static var fetchUserFavorites: String {
            return "\(NetworkConstants.shared.serverAddress)/favorites/get-favorites"
        }
        public static var removeFavorites: String {
            return "\(NetworkConstants.shared.serverAddress)/favorites/remove-favorite"
        }
        public static var addFavorites: String {
            return "\(NetworkConstants.shared.serverAddress)/favorites/add-favorite"
        }
        
        // MARK: - Posts
        public static var fetchPostByProperty: String {
            return "\(NetworkConstants.shared.serverAddress)/posts/get-posts-by-property-type"
        }
        public static var fetchAllPost: String {
            return "\(NetworkConstants.shared.serverAddress)/posts/get-all-posts"
        }
        public static var createNewPost: String {
            return "\(NetworkConstants.shared.serverAddress)/posts/create-post"
        }
        
        
        // MARK: - Search Post and User
        public static var searchPostAndUser: String {
            return "\(NetworkConstants.shared.serverAddress)/searchs/searchsPostAndUser"
        }
        
        // MARK: - Message
        public static var fetchAllMessage: String {
            return "\(NetworkConstants.shared.serverAddress)/messages/get-all-messages"
        }
        public static var fetchAllUserMessages: String {
            return "\(NetworkConstants.shared.serverAddress)/messages/get-all-user-message"
        }
        public static var sendMessage: String {
            return "\(NetworkConstants.shared.serverAddress)/messages/create"
        }
        
   }
}
