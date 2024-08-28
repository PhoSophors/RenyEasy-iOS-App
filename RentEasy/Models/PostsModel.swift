//
//  PostsModel.swift
//  RentEasy
//
//  Created by Apple on 16/8/24.
//

import Foundation

struct AllPostsResponse: Codable {
    let status: String
    let message: String
    let data: PostData
}

// Response Model for New Post
struct NewPostResponse: Codable {
    let message: String
    let data: NewPostData
}

// Data Model for New Post
struct NewPostData: Codable {
    let newPost: RentPost
}

struct PostData: Codable {
    let postsCount: Int
    let posts: [RentPost] 
}

struct RentPost: Codable {
    let id: String
    let user: [UserInfo]
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
    let version: Int

    var isFavorite: Bool = false
    
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
        case version = "__v"
    }
}
