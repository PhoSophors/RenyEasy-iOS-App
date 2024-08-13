//
//  FavoriteViewModel.swift
//  RentEasy
//
//  Created by Apple on 13/8/24.
//

import Foundation
import Combine

class FavoriteViewModel {
    
    // Properties
    @Published var favorites: [Favorite] = []
    @Published var errorMessage: String?
    
    // Fetch favorites
    func fetchFavorites() {
        APICaller.fetchUserFavorites { [weak self] result in
            DispatchQueue.main.async {
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
    func removeFavorite(_ favoriteId: String, completion: @escaping (Result<String, Error>) -> Void) {
        APICaller.removeFavorites(favoriteId: favoriteId) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let message):
                    self?.favorites.removeAll { $0.id == favoriteId }
                    completion(.success(message))
                case .failure(let error):
                    print("Error removing favorite: \(error.localizedDescription)")
                    completion(.failure(error))
                }
            }
        }
    }
}
