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


// MARK: - User Response
struct UserInfo: Codable {
    let _id: String
    let coverPhoto: String
    let profilePhoto: String
    let username: String
    let email: String
    let bio: String
    let location: String
    let createdAt: Date
}
