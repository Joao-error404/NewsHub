//
//  NewsServing.swift
//  NewsHub
//
//  Created by breno.farias on 27/10/26.
//
import Foundation

protocol NewsServing {
    func doRequest(url: URL) -> URLRequest
    func getNews() async throws -> NewsResponse
    func getNewsByRelevancy() async throws -> NewsResponse
    func searchNews(query: String) async throws -> NewsResponse
}
