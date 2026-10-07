//
//  HomeViewController.swift
//  NewsHub
//
//  Created by breno.farias on 07/10/26.
//

import UIKit

class HomeViewModel {
    private let service = NewsService()
    
    func loadNews() async {
        do {
            let response = try await service.getNews()
        } catch {
            print(error.localizedDescription)
        }
    }
}
