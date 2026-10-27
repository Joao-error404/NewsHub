//
//  NewsViewModel.swift
//  NewsHub
//
//  Created by breno.farias on 13/10/26.
//

import UIKit

class NewsViewModel {
    private let service: NewsServing
    
    init(service: NewsServing = NewsService()) {
        self.service = service
    }
    
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
