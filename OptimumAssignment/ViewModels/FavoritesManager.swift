//
//  FavoritesManager.swift
//  OptimumAssignment
//
//  Created by Deniz Sarac on 1/6/26.
//

import Combine
import Foundation

@MainActor
class FavoritesManager: ObservableObject {
    static let shared = FavoritesManager()

    @Published private(set) var favoriteContent: [MediaContent] = []

    private let favoriteContentKey = "favoriteContent"

    private init() {
        loadFavorites()
    }

    var favoriteMovies: [MediaContent] {
        favoriteContent.filter { $0.mediaType == .movie }
    }

    var favoriteTVShows: [MediaContent] {
        favoriteContent.filter { $0.mediaType == .tv }
    }

    // MARK: - Favorites Management

    func isFavorite(_ media: MediaContent) -> Bool {
        favoriteContent.contains(where: { $0.id == media.id && $0.mediaType == media.mediaType })
    }

    func toggleFavorite(_ media: MediaContent) {
        if let index = favoriteContent.firstIndex(where: { $0.id == media.id && $0.mediaType == media.mediaType }) {
            favoriteContent.remove(at: index)
        } else {
            favoriteContent.append(media)
        }
        saveFavorites()
    }

    // MARK: - Clear Favorites

    func clearAllFavorites() {
        favoriteContent.removeAll()
        saveFavorites()
    }

    func clearMovieFavorites() {
        favoriteContent.removeAll(where: { $0.mediaType == .movie })
        saveFavorites()
    }

    func clearTVShowFavorites() {
        favoriteContent.removeAll(where: { $0.mediaType == .tv })
        saveFavorites()
    }

    // MARK: - Persistence

    private func saveFavorites() {
        if let encoded = try? JSONEncoder().encode(favoriteContent) {
            UserDefaults.standard.set(encoded, forKey: favoriteContentKey)
        }
    }

    private func loadFavorites() {
        if let data = UserDefaults.standard.data(forKey: favoriteContentKey),
           let decoded = try? JSONDecoder().decode([MediaContent].self, from: data)
        {
            favoriteContent = decoded
        }
    }
}
