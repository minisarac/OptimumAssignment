//
//  APIServiceAlamo.swift
//  OptimumAssignment
//
//  Created by Deniz Sarac on 1/6/26.
//

import Foundation

enum TMDBError: Error {
    case invalidURL
    case networkError(Error)
    case decodingError(Error)
    case apiError(String)
    case invalidResponse
}

class TMDBService {
    static let shared = TMDBService()

    private init() {}

    // MARK: - Fetch Trending Movies
    func fetchTrendingMovies(timeWindow: String = "day") async throws -> [Movie] {
        guard let url = URL(string: "\(TMDBConfig.baseURL)/trending/movie/\(timeWindow)?api_key=\(TMDBConfig.apiKey)") else {
            throw TMDBError.invalidURL
        }

        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "accept")

        print("DEBUG: Fetching from URL: \(url)")

        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse else {
                throw TMDBError.invalidResponse
            }

            print("DEBUG: HTTP Status Code: \(httpResponse.statusCode)")

            guard 200...299 ~= httpResponse.statusCode else {
                if let errorString = String(data: data, encoding: .utf8) {
                    print("DEBUG: Error response: \(errorString)")
                }
                throw TMDBError.invalidResponse
            }

            let moviesResponse = try JSONDecoder().decode(TrendingMoviesResponse.self, from: data)
            print("DEBUG: Successfully decoded \(moviesResponse.results.count) movies")
            return moviesResponse.results
        } catch let error as DecodingError {
            print("DEBUG: Decoding error: \(error)")
            throw TMDBError.decodingError(error)
        } catch let error as TMDBError {
            throw error
        } catch {
            print("DEBUG: Network error: \(error)")
            throw TMDBError.networkError(error)
        }
    }

    // MARK: - Fetch Movie Details
    func fetchMovieDetails(movieId: Int) async throws -> MovieDetail {
        guard let url = URL(string: "\(TMDBConfig.baseURL)/movie/\(movieId)?api_key=\(TMDBConfig.apiKey)&append_to_response=credits,release_dates") else {
            throw TMDBError.invalidURL
        }

        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "accept")

        print("DEBUG: Fetching movie details from URL: \(url)")

        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse, 200...299 ~= httpResponse.statusCode else {
                throw TMDBError.invalidResponse
            }

            let movieDetail = try JSONDecoder().decode(MovieDetail.self, from: data)
            return movieDetail
        } catch let error as DecodingError {
            throw TMDBError.decodingError(error)
        } catch {
            throw TMDBError.networkError(error)
        }
    }

    // MARK: - Fetch Trending TV Shows
    func fetchTrendingTVShows(timeWindow: String = "day") async throws -> [TVShow] {
        guard let url = URL(string: "\(TMDBConfig.baseURL)/trending/tv/\(timeWindow)?api_key=\(TMDBConfig.apiKey)") else {
            throw TMDBError.invalidURL
        }

        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "accept")

        print("DEBUG: Fetching trending TV shows from URL: \(url)")

        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse else {
                throw TMDBError.invalidResponse
            }

            print("DEBUG: HTTP Status Code: \(httpResponse.statusCode)")

            guard 200...299 ~= httpResponse.statusCode else {
                if let errorString = String(data: data, encoding: .utf8) {
                    print("DEBUG: Error response: \(errorString)")
                }
                throw TMDBError.invalidResponse
            }

            let tvShowsResponse = try JSONDecoder().decode(TrendingTVShowsResponse.self, from: data)
            print("DEBUG: Successfully decoded \(tvShowsResponse.results.count) TV shows")
            return tvShowsResponse.results
        } catch let error as DecodingError {
            print("DEBUG: Decoding error: \(error)")
            throw TMDBError.decodingError(error)
        } catch let error as TMDBError {
            throw error
        } catch {
            print("DEBUG: Network error: \(error)")
            throw TMDBError.networkError(error)
        }
    }

    // MARK: - Fetch TV Show Details
    func fetchTVShowDetails(tvShowId: Int) async throws -> TVShowDetail {
        guard let url = URL(string: "\(TMDBConfig.baseURL)/tv/\(tvShowId)?api_key=\(TMDBConfig.apiKey)&append_to_response=credits,content_ratings") else {
            throw TMDBError.invalidURL
        }

        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "accept")

        print("DEBUG: Fetching TV show details from URL: \(url)")

        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse, 200...299 ~= httpResponse.statusCode else {
                throw TMDBError.invalidResponse
            }

            let tvShowDetail = try JSONDecoder().decode(TVShowDetail.self, from: data)
            return tvShowDetail
        } catch let error as DecodingError {
            throw TMDBError.decodingError(error)
        } catch {
            throw TMDBError.networkError(error)
        }
    }
}
