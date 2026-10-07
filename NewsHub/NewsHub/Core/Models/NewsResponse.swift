//
//  NewsResponse.swift
//  NewsHub
//
//  Created by breno.farias on 07/10/26.
//

import Foundation

struct NewsResponse: Decodable {
    let status: String?
    let totalResults: Int?
    let articles: [News]
}
