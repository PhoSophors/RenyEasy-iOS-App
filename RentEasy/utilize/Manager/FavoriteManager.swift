//
//  FavoriteManager.swift
//  RentEasy
//
//  Created by Apple on 1/9/24.
//

import Foundation

class FavoriteManager {
    private static let favoritesKey = "favorites"
    
    static func getFavorites() -> Set<String> {
        let favorites = UserDefaults.standard.stringArray(forKey: favoritesKey) ?? []
        return Set(favorites)
    }
    
    static func addFavorite(postId: String) {
        var favorites = getFavorites()
        favorites.insert(postId)
        saveFavorites(favorites)
    }
    
    static func removeFavorite(postId: String) {
        var favorites = getFavorites()
        favorites.remove(postId)
        saveFavorites(favorites)
    }
    
    static func isFavorite(postId: String) -> Bool {
        return getFavorites().contains(postId)
    }
    
    private static func saveFavorites(_ favorites: Set<String>) {
        UserDefaults.standard.set(Array(favorites), forKey: favoritesKey)
    }
}
