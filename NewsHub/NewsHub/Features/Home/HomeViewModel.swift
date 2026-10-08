//
//  HomeViewController.swift
//  NewsHub
//
//  Created by breno.farias on 07/10/26.
//

import UIKit

class HomeViewModel {
    private let service = NewsService()
    private let favoritesStore = FavoriteNewsStore()
    
    func loadNews() async -> [News] {
        do {
            let response = try await service.getNews()
            return response.articles
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
}
