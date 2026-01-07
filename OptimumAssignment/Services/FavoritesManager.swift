//
//  FavoritesManager.swift
//  OptimumAssignment
//
//  Created by Deniz Sarac on 1/6/26.
//

import Foundation
import Combine

@MainActor
class FavoritesManager: ObservableObject {
    static let shared = FavoritesManager()

    @Published private(set) var favoriteMovies: [Movie] = []
    @Published private(set) var favoriteTVShows: [TVShow] = []

    private let favoriteMoviesKey = "favoriteMovies"
    private let favoriteTVShowsKey = "favoriteTVShows"

    // Legacy property for backwards compatibility
    var favorites: [Movie] {
        return favoriteMovies
    }

    private init() {
        loadFavorites()
    }

    // MARK: - Movie Favorites

    func isFavorite(_ movie: Movie) -> Bool {
        favoriteMovies.contains(where: { $0.id == movie.id })
    }

    func toggleFavorite(_ movie: Movie) {
        if let index = favoriteMovies.firstIndex(where: { $0.id == movie.id }) {
            favoriteMovies.remove(at: index)
        } else {
            favoriteMovies.append(movie)
        }
        saveFavoriteMovies()
    }

    // MARK: - TV Show Favorites

    func isFavorite(_ tvShow: TVShow) -> Bool {
        favoriteTVShows.contains(where: { $0.id == tvShow.id })
    }

    func toggleFavorite(_ tvShow: TVShow) {
        if let index = favoriteTVShows.firstIndex(where: { $0.id == tvShow.id }) {
            favoriteTVShows.remove(at: index)
        } else {
            favoriteTVShows.append(tvShow)
        }
        saveFavoriteTVShows()
    }

    // MARK: - Clear Favorites

    func clearAllFavorites() {
        favoriteMovies.removeAll()
        favoriteTVShows.removeAll()
        saveFavoriteMovies()
        saveFavoriteTVShows()
    }

    func clearMovieFavorites() {
        favoriteMovies.removeAll()
        saveFavoriteMovies()
    }

    func clearTVShowFavorites() {
        favoriteTVShows.removeAll()
        saveFavoriteTVShows()
    }

    // MARK: - Persistence

    private func saveFavoriteMovies() {
        if let encoded = try? JSONEncoder().encode(favoriteMovies) {
            UserDefaults.standard.set(encoded, forKey: favoriteMoviesKey)
        }
    }

    private func saveFavoriteTVShows() {
        if let encoded = try? JSONEncoder().encode(favoriteTVShows) {
            UserDefaults.standard.set(encoded, forKey: favoriteTVShowsKey)
        }
    }

    private func loadFavorites() {
        // Load movies
        if let data = UserDefaults.standard.data(forKey: favoriteMoviesKey),
           let decoded = try? JSONDecoder().decode([Movie].self, from: data) {
            favoriteMovies = decoded
        }

        // Load TV shows
        if let data = UserDefaults.standard.data(forKey: favoriteTVShowsKey),
           let decoded = try? JSONDecoder().decode([TVShow].self, from: data) {
            favoriteTVShows = decoded
        }
    }
}
