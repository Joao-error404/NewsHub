//
//  News.swift
//  NewsHub
//
//  Created by breno.farias on 07/10/26.
//
import Foundation

struct News: Codable {
    let source: Source
    let author: String?
    let title: String?
    let description: String?
    let urlToImage: String?
    let publishedAt: String?
    let content: String?
}

struct Source: Codable {
    let name: String?
}
