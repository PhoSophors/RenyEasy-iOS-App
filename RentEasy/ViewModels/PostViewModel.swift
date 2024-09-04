//
//  PostViewModel.swift
//  RentEasy
//
//  Created by Apple on 20/8/24.
//

import Foundation

class PostViewModel {

    var allPosts: [RentPost] = []
    var onPostsFetched: (() -> Void)?
    var onError: ((Error) -> Void)?

    func fetchPosts(by propertyType: String?) {
        if let propertyType = propertyType {
            fetchPostsByProperty(propertyType: propertyType)
        } else {
            fetchAllPosts()
        }
    }

    private func fetchPostsByProperty(propertyType: String) {
        APICaller.fetchAllPostByProperty(propertytype: propertyType) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let allPostByProperty):
                    self?.updatePosts(with: allPostByProperty.data.posts)
                case .failure(let error):
                    self?.onError?(error)
                }
            }
        }
    }

    private func fetchAllPosts() {
        APICaller.fetchAllPosts { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let allPostsResponse):
                    self?.updatePosts(with: allPostsResponse.data.posts)
                case .failure(let error):
                    self?.onError?(error)
                }
            }
        }
    }

    private func updatePosts(with posts: [RentPost]) {
        self.allPosts = posts
        self.onPostsFetched?()
    }
}
