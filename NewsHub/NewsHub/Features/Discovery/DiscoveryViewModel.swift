//
//  DiscoveryViewModel.swift
//  NewsHub
//
//  Created by breno.farias on 08/10/26.
//

import UIKit

class DiscoveryViewModel {
    private let service = NewsService()
    
    func loadDiscoveryContent() async -> [News] {
        do {
            let response = try await service.getNewsByRelevancy()
            return response.articles
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
}
