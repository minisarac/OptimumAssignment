//
//  TVShowDetail.swift
//  OptimumAssignment
//
//  Created by Deniz Sarac on 1/6/26.
//

import Foundation

struct TVShowDetail: Codable {
    let id: Int
    let name: String
    let overview: String
    let posterPath: String?
    let backdropPath: String?
    let firstAirDate: String
    let voteAverage: Double
    let episodeRunTime: [Int]?
    let genres: [Genre]
    let tagline: String?
    let credits: TVCredits?
    let contentRatings: ContentRatingsResponse?

    enum CodingKeys: String, CodingKey {
        case id, name, overview, genres, tagline, credits
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case firstAirDate = "first_air_date"
        case voteAverage = "vote_average"
        case episodeRunTime = "episode_run_time"
        case contentRatings = "content_ratings"
    }

    var creator: String? {
        credits?.crew.first(where: { $0.job == "Creator" || $0.job == "Executive Producer" })?.name
    }

    var certification: String? {
        contentRatings?.results
            .first(where: { $0.iso_3166_1 == "US" })?
            .rating
    }

    var backdropURL: URL? {
        guard let backdropPath = backdropPath else { return nil }
        return URL(string: "\(TMDBConfig.imageBaseURL)/w1280\(backdropPath)")
    }

    var runtime: Int? {
        episodeRunTime?.first
    }
}

struct TVCredits: Codable {
    let crew: [CrewMember]
}

struct ContentRatingsResponse: Codable {
    let results: [ContentRating]
}

struct ContentRating: Codable {
    let iso_3166_1: String
    let rating: String
}
