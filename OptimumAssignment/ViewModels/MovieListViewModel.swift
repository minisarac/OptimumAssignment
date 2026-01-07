//
//  MovieListViewModel.swift
//  OptimumAssignment
//
//  Created by Deniz Sarac on 1/6/26.
//

import Foundation
import Combine

  @MainActor
  class MovieListViewModel: ObservableObject {
      @Published var movies: [Movie] = []
      @Published var isLoading = false
      @Published var errorMessage: String?

      private let service = TMDBService.shared

      func loadTrendingMovies(timeWindow: String = "day") async {
          isLoading = true
          errorMessage = nil

          do {
              movies = try await service.fetchTrendingMovies(timeWindow: timeWindow)
          } catch {
              print("DEBUG: Error loading movies: \(error)")
              if let tmdbError = error as? TMDBError {
                  switch tmdbError {
                  case .invalidURL:
                      errorMessage = "Invalid URL"
                  case .networkError(let underlying):
                      errorMessage = "Network error: \(underlying.localizedDescription)"
                  case .decodingError(let underlying):
                      errorMessage = "Decoding error: \(underlying.localizedDescription)"
                  case .invalidResponse:
                      errorMessage = "Invalid response from server"
                  case .apiError(let message):
                      errorMessage = "API error: \(message)"
                  }
              } else {
                  errorMessage = "Failed to load movies: \(error.localizedDescription)"
              }
          }

          isLoading = false
      }
  }
