//
//  MovieDetailsView.swift
//  OptimumAssignment
//
//  Created by Deniz Sarac on 1/5/26.
//

import SwiftUI

struct MovieDetailsView: View {
  let movie: Movie
  @StateObject private var favoritesManager = FavoritesManager.shared
  @State private var movieDetail: MovieDetail?
  @State private var isLoading = false
  @State private var errorMessage: String?

    var body: some View {

      ScrollView {
        VStack(alignment: .leading, spacing: 16) {

          AsyncImage(url: movieDetail?.backdropURL ?? movie.backdropURL) { phase in
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
                  Image(systemName: "film")
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
            Text(movieDetail?.title ?? movie.title)
              .font(.title2)
              .fontWeight(.semibold)

            HStack(spacing: 6) {
              if let rating = movie.rating {
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

              Text(movieDetail?.overview ?? movie.overview)
                .font(.body)
                .foregroundStyle(.secondary)

              Divider().padding(.vertical, 8)

              // Details Section
              VStack(alignment: .leading, spacing: 12) {
                if let certification = movieDetail?.certification, !certification.isEmpty {
                  DetailRow(label: "Rating", value: certification)
                }

                if let releaseDate = movieDetail?.releaseDate, !releaseDate.isEmpty {
                  DetailRow(label: "Release Date", value: releaseDate)
                }

                if let genres = movieDetail?.genres, !genres.isEmpty {
                  DetailRow(label: "Genres", value: genres.map { $0.name }.joined(separator: ", "))
                }

                if let runtime = movieDetail?.runtime {
                  let hours = runtime / 60
                  let minutes = runtime % 60
                  DetailRow(label: "Runtime", value: "\(hours)h \(minutes)m")
                }

                if let director = movieDetail?.director {
                  DetailRow(label: "Director", value: director)
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
            favoritesManager.toggleFavorite(movie)
          }) {
            Image(systemName: favoritesManager.isFavorite(movie) ? "heart.fill" : "heart")
              .foregroundStyle(favoritesManager.isFavorite(movie) ? .red : .primary)
          }
        }
      }
      .task {
        await loadMovieDetails()
      }
    }

  func loadMovieDetails() async {
    isLoading = true
    errorMessage = nil

    do {
      movieDetail = try await TMDBService.shared.fetchMovieDetails(movieId: movie.id)
    } catch {
      errorMessage = "Failed to load movie details"
      print("DEBUG: Error loading movie details: \(error)")
    }

    isLoading = false
  }
}

struct DetailRow: View {
  let label: String
  let value: String

  var body: some View {
    HStack(alignment: .top, spacing: 8) {
      Text(label + ":")
        .font(.subheadline)
        .fontWeight(.semibold)
        .foregroundStyle(.primary)
        .frame(width: 100, alignment: .leading)

      Text(value)
        .font(.subheadline)
        .foregroundStyle(.secondary)

      Spacer()
    }
  }
}

#Preview {
  MovieDetailsView(movie: Movie(id: 1, title: "Sample Movie Title", overview: "This is a sample movie overview", posterPath: nil, backdropPath: nil, releaseDate: "2024-06-15", voteAverage: 7.8, voteCount: 1000, popularity: 100.0))
}
