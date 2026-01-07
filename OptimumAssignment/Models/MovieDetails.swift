//
//  MovieDetails.swift
//  OptimumAssignment
//
//  Created by Deniz Sarac on 1/6/26.
//

import Foundation

struct MovieDetail: Codable {
    let id: Int
    let title: String
    let overview: String
    let posterPath: String?
    let backdropPath: String?
    let releaseDate: String
    let voteAverage: Double
    let runtime: Int?
    let genres: [Genre]
    let tagline: String?
    let credits: Credits?
    let releaseDates: ReleaseDatesResponse?

    enum CodingKeys: String, CodingKey {
        case id, title, overview, runtime, genres, tagline, credits
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
        case releaseDates = "release_dates"
    }

    var director: String? {
        credits?.crew.first(where: { $0.job == "Director" })?.name
    }

    var certification: String? {
        releaseDates?.results
            .first(where: { $0.iso_3166_1 == "US" })?
            .releaseDates
            .first?.certification
    }

    var backdropURL: URL? {
        guard let backdropPath = backdropPath else { return nil }
        return URL(string: "\(TMDBConfig.imageBaseURL)/w1280\(backdropPath)")
    }
}

struct Genre: Codable, Identifiable {
    let id: Int
    let name: String
}

struct Credits: Codable {
    let crew: [CrewMember]
}

struct CrewMember: Codable {
    let name: String
    let job: String
}

struct ReleaseDatesResponse: Codable {
    let results: [ReleaseDate]
}

struct ReleaseDate: Codable {
    let iso_3166_1: String
    let releaseDates: [ReleaseDateDetail]

    enum CodingKeys: String, CodingKey {
        case iso_3166_1
        case releaseDates = "release_dates"
    }
}

struct ReleaseDateDetail: Codable {
    let certification: String
}
