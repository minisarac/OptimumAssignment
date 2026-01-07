//
//  NetworkManager.swift
//  OptimumAssignment
//
//  Created by Deniz Sarac on 1/6/26.
//

import Alamofire
import Foundation

final class NetworkManager {
    static let shared = NetworkManager()

    private let session: Session
    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()

    private init() {
        let cache = URLCache(
            memoryCapacity: 50_000_000,
            diskCapacity: 100_000_000,
            diskPath: "tmdb_cache"
        )

        let configuration = URLSessionConfiguration.af.default
        configuration.urlCache = cache

        let interceptor = AuthInterceptor()
        session = Session(configuration: configuration, interceptor: interceptor)
    }

    // MARK: - Generic Request

    func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T {
        try await session.request(endpoint)
            .cacheResponse(using: .cache)
            .validate()
            .serializingDecodable(T.self, decoder: decoder)
            .value
    }

    // MARK: - Trending

    func fetchTrending(_ type: MediaType, period: TrendingPeriod = .day) async throws -> MediaContentResponse {
        try await request(.trending(type, period))
    }

    // MARK: - Details

    func fetchMovieDetails(movieId: Int) async throws -> MovieDetail {
        try await request(.movieDetail(id: movieId))
    }

    func fetchTVShowDetails(tvShowId: Int) async throws -> TVShowDetail {
        try await request(.tvDetail(id: tvShowId))
    }
}

nonisolated struct MediaContentResponse: Codable {
    let results: [MediaContent]
}

// MARK: - Auth Interceptor

private struct AuthInterceptor: RequestInterceptor {
    func adapt(_ urlRequest: URLRequest, for _: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var request = urlRequest
        request.setValue("Bearer \(EndpointConfig.apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        completion(.success(request))
    }
}
