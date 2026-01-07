//
//  Endpoint.swift
//  OptimumAssignment
//
//  Created by Deniz Sarac on 1/6/26.
//

import Alamofire
import Foundation

// MARK: - Endpoint

enum Endpoint: URLRequestConvertible {
    case trending(MediaType, TrendingPeriod)
    case movieDetail(id: Int)
    case tvDetail(id: Int)

    func asURLRequest() throws -> URLRequest {
        let url: URL
        var parameters: [String: String]? = nil

        switch self {
        case let .trending(type, period):
            url = try "\(EndpointConfig.baseURL)/trending/\(type.rawValue)/\(period.rawValue)".asURL()
        case let .movieDetail(id):
            url = try "\(EndpointConfig.baseURL)/movie/\(id)".asURL()
            parameters = ["append_to_response": "credits,release_dates"]
        case let .tvDetail(id):
            url = try "\(EndpointConfig.baseURL)/tv/\(id)".asURL()
            parameters = ["append_to_response": "credits,content_ratings"]
        }

        return try URLEncoding.default.encode(URLRequest(url: url), with: parameters)
    }

    static func imageURL(path: String?, size: ImageSize) -> URL? {
        guard let path else { return nil }
        return URL(string: "\(EndpointConfig.imageBaseURL)\(size.rawValue)\(path)")
    }
}

enum EndpointConfig {
    static let apiKey: String = {
        guard let path = Bundle.main.path(forResource: "Config", ofType: "plist"),
              let config = NSDictionary(contentsOfFile: path),
              let key = config["TMDB_API_KEY"] as? String
        else {
            fatalError("Config.plist not found or TMDB_API_KEY missing.")
        }
        return key
    }()

    static let baseURL = "https://api.themoviedb.org/3"
    static let imageBaseURL = "https://image.tmdb.org/t/p/"
}

// MARK: - Image Size

enum ImageSize: String, Sendable {
    // Posters
    case posterMedium = "w342"
    case posterLarge = "w780"

    // Backdrops
    case backdropSmall = "w300"
    case backdropLarge = "w1280"

    case original
}
