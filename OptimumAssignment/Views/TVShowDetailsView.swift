//
//  TVShowDetailsView.swift
//  OptimumAssignment
//
//  Created by Deniz Sarac on 1/6/26.
//

import SwiftUI

struct TVShowDetailsView: View {
  let tvShow: TVShow
  @StateObject private var favoritesManager = FavoritesManager.shared
  @State private var tvShowDetail: TVShowDetail?
  @State private var isLoading = false
  @State private var errorMessage: String?

  var body: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: 16) {

        AsyncImage(url: tvShowDetail?.backdropURL ?? tvShow.backdropURL) { phase in
          switch phase {
          case .empty:
            RoundedRectangle(cornerRadius: 0)
              .fill(.gray.opacity(0.2))
              .frame(maxWidth: .infinity)
              .aspectRatio(16/9, contentMode: .fit)
              .overlay(
                ProgressView()
              )
          case .success(let image):
            image
              .resizable()
              .aspectRatio(contentMode: .fill)
              .frame(maxWidth: .infinity)
              .aspectRatio(16/9, contentMode: .fit)
              .clipped()
          case .failure:
            RoundedRectangle(cornerRadius: 0)
              .fill(.gray.opacity(0.2))
              .frame(maxWidth: .infinity)
              .aspectRatio(16/9, contentMode: .fit)
              .overlay(
                Image(systemName: "tv")
                  .font(.system(size: 44))
                  .foregroundStyle(.gray)
              )
          @unknown default:
            RoundedRectangle(cornerRadius: 0)
              .fill(.gray.opacity(0.2))
              .frame(maxWidth: .infinity)
              .aspectRatio(16/9, contentMode: .fit)
          }
        }

        VStack(alignment: .leading, spacing: 8) {
          Text(tvShowDetail?.name ?? tvShow.name)
            .font(.title2)
            .fontWeight(.semibold)

          HStack(spacing: 6) {
            if let rating = tvShow.rating {
              Image(systemName: "star.fill")
                .foregroundStyle(.yellow)
              Text(String(format: "%.1f", rating))
            }
          }
          .font(.subheadline)
          .foregroundStyle(.secondary)

          Divider().padding(.vertical, 8)

          if isLoading {
            ProgressView()
              .frame(maxWidth: .infinity)
          } else if let error = errorMessage {
            Text(error)
              .foregroundColor(.red)
              .font(.caption)
          } else {
            // Overview Section
            Text("Overview")
              .font(.headline)

            Text(tvShowDetail?.overview ?? tvShow.overview)
              .font(.body)
              .foregroundStyle(.secondary)

            Divider().padding(.vertical, 8)

            // Details Section
            VStack(alignment: .leading, spacing: 12) {
              if let certification = tvShowDetail?.certification, !certification.isEmpty {
                DetailRow(label: "Rating", value: certification)
              }

              if let firstAirDate = tvShowDetail?.firstAirDate, !firstAirDate.isEmpty {
                DetailRow(label: "First Air Date", value: firstAirDate)
              }

              if let genres = tvShowDetail?.genres, !genres.isEmpty {
                DetailRow(label: "Genres", value: genres.map { $0.name }.joined(separator: ", "))
              }

              if let runtime = tvShowDetail?.runtime {
                DetailRow(label: "Episode Runtime", value: "\(runtime) min")
              }

              if let creator = tvShowDetail?.creator {
                DetailRow(label: "Creator", value: creator)
              }
            }
          }
        }
        .padding(.horizontal)
      }
      .padding(.top)
    }
    .navigationTitle("Details")
    .navigationBarTitleDisplayMode(.inline)
    .toolbar {
      ToolbarItem(placement: .navigationBarTrailing) {
        Button(action: {
          favoritesManager.toggleFavorite(tvShow)
        }) {
          Image(systemName: favoritesManager.isFavorite(tvShow) ? "heart.fill" : "heart")
            .foregroundStyle(favoritesManager.isFavorite(tvShow) ? .red : .primary)
        }
      }
    }
    .task {
      await loadTVShowDetails()
    }
  }

  func loadTVShowDetails() async {
    isLoading = true
    errorMessage = nil

    do {
      tvShowDetail = try await TMDBService.shared.fetchTVShowDetails(tvShowId: tvShow.id)
    } catch {
      errorMessage = "Failed to load TV show details"
      print("DEBUG: Error loading TV show details: \(error)")
    }

    isLoading = false
  }
}

#Preview {
  TVShowDetailsView(tvShow: TVShow(id: 1, name: "Sample TV Show", overview: "This is a sample TV show overview", posterPath: nil, backdropPath: nil, firstAirDate: "2024-06-15", voteAverage: 7.8, voteCount: 1000, popularity: 100.0))
}
