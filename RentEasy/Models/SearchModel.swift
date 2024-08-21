//
//  SearchModel.swift
//  RentEasy
//
//  Created by Apple on 21/8/24.
//

import Foundation

struct SearchResponse: Codable {
    let status: String
    let data: DataContainer

    struct DataContainer: Codable {
        let users: [UserInfo]
        let posts: [RentPost]
    }
}
