//
//  FavoritesView.swift
//  OptimumAssignment
//
//  Created by Deniz Sarac on 1/5/26.
//

import SwiftUI

struct FavoritesView: View {
    @StateObject private var favoritesManager = FavoritesManager.shared
    @StateObject private var settings = AppSettings.shared
    @State private var showingClearAlert = false

    var filteredContent: [MediaContent] {
        let content: [MediaContent]
        switch settings.contentType {
        case .all:
            content = favoritesManager.favoriteContent
        case .movies:
            content = favoritesManager.favoriteMovies
        case .tv:
            content = favoritesManager.favoriteTVShows
        }
        return content
    }

    var hasNoFavorites: Bool {
        filteredContent.isEmpty
    }

    var body: some View {
        NavigationStack {
            Group {
                if hasNoFavorites {
                    VStack(spacing: 16) {
                        Image(systemName: "heart.slash")
                            .font(.system(size: 60))
                            .foregroundStyle(.gray)
                        Text("No Favorites Yet")
                            .font(.title2)
                            .fontWeight(.semibold)
                        Text("Tap the heart icon on any movie or TV show to add it to your favorites")
                            .font(.body)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List {
                        ForEach(sortedContent) { media in
                            NavigationLink {
                                MediaDetailsView(media: media)
                            } label: {
                                FavoriteContentRow(media: media)
                            }
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Favorites")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Clear") {
                        showingClearAlert = true
                    }
                    .disabled(hasNoFavorites)
                }
            }
            .alert("Clear Favorites", isPresented: $showingClearAlert) {
                Button("Cancel", role: .cancel) {}
                Button("Clear All", role: .destructive) {
                    if settings.contentType == .all {
                        favoritesManager.clearAllFavorites()
                    } else if settings.contentType == .movies {
                        favoritesManager.clearMovieFavorites()
                    } else {
                        favoritesManager.clearTVShowFavorites()
                    }
                }
            } message: {
                if settings.contentType == .all {
                    Text("Are you sure you want to clear all favorite movies and TV shows?")
                } else if settings.contentType == .movies {
                    Text("Are you sure you want to clear all favorite movies?")
                } else {
                    Text("Are you sure you want to clear all favorite TV shows?")
                }
            }
        }
    }

    var sortedContent: [MediaContent] {
        switch settings.sortOption {
        case .rating:
            return filteredContent.sorted { $0.voteAverage > $1.voteAverage }
        case .releaseDate:
            return filteredContent.sorted { $0.year ?? "" > $1.year ?? "" }
        case .popularity:
            return filteredContent.sorted { $0.popularity > $1.popularity }
        case .title:
            return filteredContent.sorted { $0.contentTitle < $1.contentTitle }
        }
    }
}

#Preview {
    FavoritesView()
}
