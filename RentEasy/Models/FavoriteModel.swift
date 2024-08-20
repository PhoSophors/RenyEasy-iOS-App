//
//  FavoriteModel.swift
//  RentEasy
//
//  Created by Apple on 13/8/24.
//

import Foundation

struct FavoriteResponse: Codable {
    let status: String
    let data: FavoriteData
}

struct FavoriteData: Codable {
    let favoritesCount: Int
    let favorites: [Favorite]
}

struct Favorite: Codable {
    let id: String
    let user: [UserInfo]
    let post: RentPost
    let createdAt: String
    let v: Int

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case user
        case post
        case createdAt
        case v = "__v"
    }
}
