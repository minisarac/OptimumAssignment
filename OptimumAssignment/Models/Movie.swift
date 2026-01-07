//
//  Movie.swift
//  OptimumAssignment
//
//  Created by Deniz Sarac on 1/5/26.
//

import Foundation

struct Movie: Identifiable, Equatable, Hashable, Codable {
  let id: Int
  let title: String
  let overview: String
  let posterPath: String?
  let backdropPath: String?
  let releaseDate: String
  let voteAverage: Double
  let voteCount: Int
  let popularity: Double
  
  var rating: Double? {
    return voteAverage
  }
  
  var year: String {
    String(releaseDate.prefix(4))
  }

  enum CodingKeys: String, CodingKey {
      case id, title, overview, popularity
      case posterPath = "poster_path"
      case backdropPath = "backdrop_path"
      case releaseDate = "release_date"
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
}

extension Array where Element == Movie {
    func sorted(by option: SortOption) -> [Movie] {
        switch option {
        case .rating:
            return self.sorted { $0.voteAverage > $1.voteAverage }
        case .releaseDate:
            return self.sorted { $0.releaseDate > $1.releaseDate }
        case .popularity:
            return self.sorted { $0.popularity > $1.popularity }
        case .title:
            return self.sorted { $0.title.localizedCaseInsensitiveCompare($1.title) == .orderedAscending }
        }
    }
}
