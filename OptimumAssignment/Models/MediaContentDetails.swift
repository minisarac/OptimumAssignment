//
//  MediaContentDetails.swift
//  OptimumAssignment
//
//  Created by Deniz Sarac on 1/7/26.
//

import Foundation

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

struct MovieDetail: Codable {
    let runtime: Int?
    let genres: [Genre]
    let credits: Credits?
    let releaseDates: MovieCertificationResponse?
}

struct TVShowDetail: Codable {
    let episodeRunTime: [Int]?
    let genres: [Genre]
    let credits: Credits?
    let contentRatings: TVCertificationResponse?
}

extension MovieDetail {
    var director: String? {
        credits?.crew.first(where: { $0.job == "Director" })?.name
    }

    var certification: String? {
        releaseDates?.results
            .first(where: { $0.iso31661 == "US" })?
            .releaseDates
            .first?.certification
    }
}

extension TVShowDetail {
    var creator: String? {
        credits?.crew.first(where: { $0.job == "Creator" || $0.job == "Executive Producer" })?.name
    }

    var runtime: Int? {
        episodeRunTime?.first
    }

    var certification: String? {
        contentRatings?.results
            .first(where: { $0.iso31661 == "US" })?
            .rating
    }
}

struct MovieCertificationResponse: Codable {
    let results: [ReleaseDate]

    struct ReleaseDate: Codable {
        let iso31661: String
        let releaseDates: [ReleaseDateDetail]

        struct ReleaseDateDetail: Codable {
            let certification: String
        }
    }
}

struct TVCertificationResponse: Codable {
    let results: [ContentRating]

    struct ContentRating: Codable {
        let iso31661: String
        let rating: String
    }
}
