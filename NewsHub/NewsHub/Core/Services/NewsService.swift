//
//  NewsService.swift
//  NewsHub
//
//  Created by breno.farias on 07/10/26.
//

import Foundation

class NewsService {
    
    let baseURL = "https://newsapi.org/v2/everything"
    
    func doRequest(url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.setValue(
            "Bearer \(ProcessInfo.processInfo.environment["API_KEY"]!)",
            forHTTPHeaderField: "Authorization"
        )
        return request
    }
    
    func getNews() async throws -> NewsResponse {
        var components = URLComponents(string: baseURL)!
        components.queryItems = [
            URLQueryItem(name: "language", value: "pt"),
            URLQueryItem(name: "sortBy", value: "publishedAt"),
            URLQueryItem(name: "pageSize", value: "10"),
            URLQueryItem(name: "page", value: "1"),
            URLQueryItem(name: "q", value: "noticia")
        ]
        
        guard let url = components.url else { throw URLError(.badURL) }
        let request = doRequest(url: url)
        let (data, _) = try await URLSession.shared.data(for: request)
        
        return try JSONDecoder().decode(NewsResponse.self, from: data)
    }
    
    func getNewsByRelevancy() async throws -> NewsResponse {
        var components = URLComponents(string: baseURL)!
        components.queryItems = [
            URLQueryItem(name: "language", value: "pt"),
            URLQueryItem(name: "sortBy", value: "relevancy"),
            URLQueryItem(name: "pageSize", value: "20"),
            URLQueryItem(name: "page", value: "1"),
            URLQueryItem(name: "q", value: "noticia")
        ]
        
        guard let url = components.url else { throw URLError(.badURL) }
        let request = doRequest(url: url)
        let (data, _) = try await URLSession.shared.data(for: request)
        
        return try JSONDecoder().decode(NewsResponse.self, from: data)
    }
    
    func searchNews(query: String) async throws -> NewsResponse {
        var components = URLComponents(string: baseURL)!
        components.queryItems = [
            URLQueryItem(name: "language", value: "pt"),
            URLQueryItem(name: "sortBy", value: "relevancy"),
            URLQueryItem(name: "pageSize", value: "20"),
            URLQueryItem(name: "page", value: "1"),
            URLQueryItem(name: "q", value: query)
        ]
        
        guard let url = components.url else { throw URLError(.badURL) }
        let request = doRequest(url: url)
        let (data, _) = try await URLSession.shared.data(for: request)
        
        return try JSONDecoder().decode(NewsResponse.self, from: data)
    }
}
