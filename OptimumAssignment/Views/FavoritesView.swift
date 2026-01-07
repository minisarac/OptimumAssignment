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

  var filteredMovies: [Movie] {
    guard settings.contentType != .tv else { return [] }
    return favoritesManager.favoriteMovies.sorted(by: settings.sortOption)
  }

  var filteredTVShows: [TVShow] {
    guard settings.contentType != .movies else { return [] }
    return favoritesManager.favoriteTVShows.sorted(by: settings.sortOption)
  }

  var hasAnyFavorites: Bool {
    !filteredMovies.isEmpty || !filteredTVShows.isEmpty
  }

  var body: some View {
    NavigationStack {
      Group {
        if !hasAnyFavorites {
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
            // Movies Section
            ForEach(filteredMovies) { movie in
              NavigationLink {
                MovieDetailsView(movie: movie)
              } label: {
                FavoriteMovieRow(movie: movie)
              }
            }

            // TV Shows Section
            ForEach(filteredTVShows) { tvShow in
              NavigationLink {
                TVShowDetailsView(tvShow: tvShow)
              } label: {
                FavoriteTVShowRow(tvShow: tvShow)
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
          .disabled(!hasAnyFavorites)
        }
      }
      .alert("Clear Favorites", isPresented: $showingClearAlert) {
        Button("Cancel", role: .cancel) { }
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
}

#Preview {
    FavoritesView()
}
