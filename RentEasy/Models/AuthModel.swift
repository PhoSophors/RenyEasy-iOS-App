//
//  AuthModel.swift
//  RentEasy
//
//  Created by Apple on 5/8/24.
//

import Foundation

// MARK: Login Model
struct LoginModel: Codable {
    let email: String
    let password: String
}

// MARK: User repsone
struct UserInfo: Codable {
    let _id: String
    let coverPhoto: String
    let profilePhoto: String
    let username: String
    let email: String
    let bio: String
    let location: String
    let createdAt: Date  // Change to Date type
}

