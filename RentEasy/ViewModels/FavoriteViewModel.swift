//
//  FavoriteViewModel.swift
//  RentEasy
//
//  Created by Apple on 13/8/24.
//

import Foundation
import Combine

protocol FavoriteViewModelDelegate: AnyObject {
    func showLoadingOverlay()
    func hideLoadingOverlay()
}

class FavoriteViewModel {
    weak var delegate: FavoriteViewModelDelegate?
    
    // Properties
    @Published var favorites: [Favorite] = []
    @Published var errorMessage: String?
    private var favoritePostIds: Set<String> = Set()
    private var userInfo: UserInfo?
    
    // Fetch favorites
      func fetchFavorites() {
          delegate?.showLoadingOverlay()
          
          APICaller.fetchUserFavorites { [weak self] result in
              DispatchQueue.main.async {
                  self?.delegate?.hideLoadingOverlay()
                  
                  switch result {
                  case .success(let favorites):
                      self?.favorites = favorites
                      self?.errorMessage = nil
                  case .failure(let error):
                      self?.favorites = []
                      self?.errorMessage = error.localizedDescription
                  }
              }
          }
      }
    
    // Remove a specific favorite
    func removeFavorite(postId: String, completion: @escaping (Result<String, Error>) -> Void) {
        APICaller.removeFavorites(postId: postId) { [weak self] result in
            DispatchQueue.main.async {
                guard let strongSelf = self else { return }
                
                switch result {
                case .success(let message):
                    // Ensure thread-safety while modifying the favorites array
                    if let index = strongSelf.favorites.firstIndex(where: { $0.post.id == postId }) {
                        strongSelf.favorites.remove(at: index)
                    } else {
                        print("Error: Post ID \(postId) not found in favorites")
                    }
                    completion(.success(message))
                case .failure(let error):
                    print("Error removing favorite: \(error.localizedDescription)")
                    completion(.failure(error))
                }
            }
        }
    }
    
    // Check if a post is a user favorite
    func isFavorite(postId: String) -> Bool {
        if let userInfo = userInfo {
            return userInfo.favorites.contains(postId)
        }
        return false
    }

    // Update user info
    func updateUserInfo(_ userInfo: UserInfo) {
        self.userInfo = userInfo
    }
    
    // Add a specific favorite
    func addFavorite(postId: String, completion: @escaping (Result<String, Error>) -> Void) {
        delegate?.showLoadingOverlay()
        
        APICaller.addFavorites(postId: postId) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let message):
                    self?.favoritePostIds.insert(postId)
                    // Optionally, update favorites list if needed
                    completion(.success(message))
                    
                case .failure(let error):
                    completion(.failure(error))
                }
                
                self?.delegate?.hideLoadingOverlay()
            }
        }
    }

    
}
