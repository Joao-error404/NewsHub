//
//  FavoriteNewsStore.swift
//  NewsHub
//
//  Created by breno.farias on 08/10/26.
//

import Combine
import Foundation

@MainActor
class FavoriteNewsStore {
    // instancia padrao para o card ser salvo em todas as telas
    static let shared = FavoriteNewsStore()

    enum StoreError: Error {
        case missingURL
    }

    private let userDefaults: UserDefaults
    private let key = "favorite_news"
    
    
    @Published private(set) var favorites: [News] = []
    
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
        loadFavorites()
    }
    
    func load() async throws {
        loadFavorites()
    }
    
    func toggle(_ news: News) async throws {
        guard canFavorite(news) else { throw StoreError.missingURL }

        var updatedFavorites = favorites
        
        if let index = updatedFavorites.firstIndex(where: { $0.url == news.url }) {
            updatedFavorites.remove(at: index)
        } else {
            updatedFavorites.append(news)
        }

        let data = try JSONEncoder().encode(updatedFavorites)
        userDefaults.set(data, forKey: key)
        favorites = updatedFavorites
    }
    
    func isFavorite(_ news: News) -> Bool {
        return canFavorite(news) && favorites.contains(where: { $0.url == news.url })
    }

    func canFavorite(_ news: News) -> Bool {
        guard let url = news.url else { return false }
        return !url.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    private func loadFavorites() {
        guard let data = userDefaults.data(forKey: key),
              let decodedNews = try? JSONDecoder().decode([News].self, from: data) else {
            favorites = []
            return
        }
        
        favorites = decodedNews
    }
}
