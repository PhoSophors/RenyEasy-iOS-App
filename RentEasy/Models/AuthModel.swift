//
//  AuthModel.swift
//  RentEasy
//
//  Created by Apple on 5/8/24.
//

import Foundation

// MARK: - Login Model
struct LoginModel: Codable {
    let email: String
    let password: String
}

// MARK: - Register
struct RegisterModel: Codable {
    let username: String
    let email: String
    let password: String
    let confirmPassword: String
}

// MARK: Verify Register OTP
struct VerifyRegisterOTP: Codable {
    let email: String
    let otp: String
}

// MARK: Verify Register OTP Response
struct VerifyRegisterOTPResponse: Codable {
    let message: String
    let token: String
}

// MARK: - Forgot password
struct RequestNewPasswordModel: Codable {
    let email: String
}

// MARK: Verify Reset Password OTP
struct VerifyNewPasswordOTPModel: Codable {
    let email: String
    let otp: String
}

// MARK: Verify New Password OTP Response
struct VerifyNewPasswordOTPResponse: Decodable {
    let message: String
}

// MARK: Reset New Password
struct NewPasswordModel: Codable {
    var email: String
    var newPassword: String
    var confirmPassword: String
}

// MARK: - Update user info response
struct UpdateUserInfoResponse: Codable { 
    let message: String
    let user: UserInfo
}

// MARK: - User Response
struct UserInfo: Codable {
    let id: String
    let coverPhoto: String
    let profilePhoto: String
    let username: String
    let email: String
    let bio: String
    let location: String
    let isVerified: Bool
    let roles: [Role]
    let posts: [String]
    let favorites: [String]
    let messages: [String]
    let messagedUsers: [String]
    let createdAt: String
    let version: Int
    let refreshToken: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case coverPhoto
        case profilePhoto
        case username
        case email
        case bio
        case location
        case isVerified
        case roles
        case posts
        case favorites
        case messages
        case messagedUsers
        case createdAt
        case version = "__v"
        case refreshToken
    }
}

// Define the Role struct
struct Role: Codable {
    let name: String
    let permissions: [String]
    let id: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case permissions
        case id = "_id"
    }
}
