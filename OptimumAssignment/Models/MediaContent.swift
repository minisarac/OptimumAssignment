//
//  MediaContent.swift
//  OptimumAssignment
//
//  Created by Deniz Sarac on 1/6/26.
//

import Foundation

enum MediaType: String, Codable {
    case movie
    case tv

    var title: String {
        switch self {
        case .movie:
            "Movies"
        case .tv:
            "TV Shows"
        }
    }
}

struct MediaContent: Identifiable, Equatable, Hashable, Codable {
    let id: Int
    let name: String?
    let title: String?
    let overview: String
    let posterPath: String?
    let backdropPath: String?
    let releaseDate: String?
    let firstAirDate: String?
    let voteAverage: Double
    let voteCount: Int
    let popularity: Double
    let mediaType: MediaType
}

extension MediaContent {
    var contentTitle: String {
        if mediaType == .movie {
            return title ?? ""
        } else {
            return name ?? ""
        }
    }

    var year: String? {
        if mediaType == .movie,
           let releaseDate
        {
            return String(releaseDate.prefix(4))
        } else if mediaType == .tv,
                  let firstAirDate
        {
            return String(firstAirDate.prefix(4))
        }

        return nil
    }

    var posterURL: URL? {
        Endpoint.imageURL(path: posterPath, size: .posterLarge)
    }

    var backdropURL: URL? {
        Endpoint.imageURL(path: backdropPath, size: .backdropSmall)
    }
}
