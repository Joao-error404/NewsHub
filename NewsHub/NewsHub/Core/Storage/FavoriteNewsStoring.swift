//
//  FavoriteNewsStoring.swift
//  NewsHub
//
//  Created by breno.farias on 27/10/26.
//

import Combine

@MainActor
protocol FavoriteNewsStoring {
    var favorites: [News] { get }
    var favoritesPublisher: AnyPublisher<[News], Never> { get }
    
    func load() async throws
    func toggle(_ news: News) async throws
    func isFavorite(_ news: News) -> Bool
    func canFavorite(_ news: News) -> Bool
}
