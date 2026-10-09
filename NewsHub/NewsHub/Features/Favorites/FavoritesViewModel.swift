//
//  FavoritesViewModel.swift
//  NewsHub
//
//  Created by breno.farias on 09/10/26.
//

import UIKit

class FavoritesViewModel {
    private let service = NewsService()
    private let favoritesStore = FavoriteNewsStore.shared
    
    private(set) var favoriteNews: [News] = []
    
    func loadFavorites() async {
        do {
            try await favoritesStore.load()
            favoriteNews = favoritesStore.favorites
        } catch {
            print(error.localizedDescription)
        }
    }
    
}
