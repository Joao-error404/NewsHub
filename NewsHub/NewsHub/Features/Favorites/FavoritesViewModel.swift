//
//  FavoritesViewModel.swift
//  NewsHub
//
//  Created by breno.farias on 09/10/26.
//

import UIKit

@MainActor
class FavoritesViewModel {
    private let service: NewsServing
    private let store: FavoriteNewsStoring
    private(set) var favoriteNews: [News] = []
    
    init(
        service: NewsServing? = nil,    
        favoritesStore: FavoriteNewsStoring? = nil) {
            self.service = service ?? NewsService()
            self.store = favoritesStore ?? FavoriteNewsStore.shared
    }
    
    func loadFavorites() async {
        do {
            try await store.load()
            favoriteNews = store.favorites
        } catch {
            print(error.localizedDescription)
        }
    }
    
}
