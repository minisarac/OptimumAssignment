//
//  FavoriteMovieRow.swift
//  OptimumAssignment
//
//  Created by Deniz Sarac on 1/6/26.
//

import SwiftUI

struct FavoriteMovieRow: View {
  let movie: Movie
  @StateObject private var favoritesManager = FavoritesManager.shared

  var body: some View {
    HStack(spacing: 12) {
      // Backdrop Image
      AsyncImage(url: movie.backdropURL) { phase in
        switch phase {
        case .empty:
          RoundedRectangle(cornerRadius: 8)
            .fill(.gray.opacity(0.2))
            .frame(width: 120, height: 68)
            .overlay(
              ProgressView()
            )
        case .success(let image):
          image
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 120, height: 68)
            .clipShape(RoundedRectangle(cornerRadius: 8))
        case .failure:
          RoundedRectangle(cornerRadius: 8)
            .fill(.gray.opacity(0.2))
            .frame(width: 120, height: 68)
            .overlay(
              Image(systemName: "film")
                .foregroundStyle(.gray)
            )
        @unknown default:
          RoundedRectangle(cornerRadius: 8)
            .fill(.gray.opacity(0.2))
            .frame(width: 120, height: 68)
        }
      }

      // Movie Info
      VStack(alignment: .leading, spacing: 4) {
          Text(movie.title)
            .font(.headline)
            .lineLimit(2)

        HStack(spacing: 8) {
          if let rating = movie.rating {
            Image(systemName: "star.fill")
              .font(.caption)
              .foregroundStyle(.yellow)
            Text(String(format: "%.1f", rating))
              .font(.caption)
              .foregroundStyle(.secondary)
          }

          if !movie.releaseDate.isEmpty {
            Text("•")
              .foregroundStyle(.secondary)
            Text(movie.year)
              .font(.caption)
              .foregroundStyle(.secondary)
          }
      
        }
        
        Text("Movie")
          .font(.caption2)
          .fontWeight(.semibold)
          .foregroundStyle(.white)
          .padding(.horizontal, 6)
          .padding(.vertical, 2)
          .background(Capsule().fill(.blue))
      }

      Spacer()

      // Heart Button
      Button(action: {
        favoritesManager.toggleFavorite(movie)
      }) {
        Image(systemName: "heart.fill")
          .font(.system(size: 20))
          .foregroundStyle(.red)
      }
      .buttonStyle(.plain)
    }
    .padding(.vertical, 8)
  }
}

#Preview {
  FavoriteMovieRow(movie: Movie(id: 1, title: "Sample Movie Title", overview: "This is a sample movie overview", posterPath: nil, backdropPath: nil, releaseDate: "2024-06-15", voteAverage: 7.8, voteCount: 1000, popularity: 100.0))
}
