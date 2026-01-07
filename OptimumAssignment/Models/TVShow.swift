//
//  TVShow.swift
//  OptimumAssignment
//
//  Created by Deniz Sarac on 1/6/26.
//

import Foundation

struct TVShow: Identifiable, Equatable, Hashable, Codable {
  let id: Int
  let name: String
  let overview: String
  let posterPath: String?
  let backdropPath: String?
  let firstAirDate: String
  let voteAverage: Double
  let voteCount: Int
  let popularity: Double

  var rating: Double? {
    return voteAverage
  }

  enum CodingKeys: String, CodingKey {
      case id, name, overview, popularity
      case posterPath = "poster_path"
      case backdropPath = "backdrop_path"
      case firstAirDate = "first_air_date"
      case voteAverage = "vote_average"
      case voteCount = "vote_count"
  }

  var posterURL: URL? {
      guard let posterPath = posterPath else { return nil }
      return URL(string: "\(TMDBConfig.imageBaseURL)/w500\(posterPath)")
  }

  var backdropURL: URL? {
      guard let backdropPath = backdropPath else { return nil }
      return URL(string: "\(TMDBConfig.imageBaseURL)/w1280\(backdropPath)")
  }

  var releaseDate: String {
      return firstAirDate
  }

  var title: String {
      return name
  }
}

struct TrendingTVShowsResponse: Codable {
    let page: Int
    let results: [TVShow]
    let totalPages: Int
    let totalResults: Int

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

extension Array where Element == TVShow {
    func sorted(by option: SortOption) -> [TVShow] {
        switch option {
        case .rating:
            return self.sorted { $0.voteAverage > $1.voteAverage }
        case .releaseDate:
            return self.sorted { $0.firstAirDate > $1.firstAirDate }
        case .popularity:
            return self.sorted { $0.popularity > $1.popularity }
        case .title:
            return self.sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
        }
    }
}
