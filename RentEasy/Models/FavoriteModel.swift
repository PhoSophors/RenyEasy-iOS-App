//
//  FavoriteModel.swift
//  RentEasy
//
//  Created by Apple on 13/8/24.
//

import Foundation

// Define the structure for the JSON response
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
    let user: String
    let post: Post
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

struct Post: Codable {
    let id: String
    let user: String
    let title: String
    let content: String
    let images: [String]
    let contact: String
    let location: String
    let price: Int
    let bedrooms: Int
    let bathrooms: Int
    let propertyType: String
    let createdAt: String
    let v: Int

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case user
        case title
        case content
        case images
        case contact
        case location
        case price
        case bedrooms
        case bathrooms
        case propertyType = "propertytype"
        case createdAt
        case v = "__v"
    }
}
