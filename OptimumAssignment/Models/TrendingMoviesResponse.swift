//
//  TrendingMoviesResponse.swift
//  OptimumAssignment
//
//  Created by Deniz Sarac on 1/6/26.
//

import Foundation

struct TrendingMoviesResponse: Codable {
    let page: Int
    let results: [Movie]
    let totalPages: Int
    let totalResults: Int

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}


