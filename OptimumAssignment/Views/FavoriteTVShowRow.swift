//
//  FavoriteTVShowRow.swift
//  OptimumAssignment
//
//  Created by Deniz Sarac on 1/6/26.
//

import SwiftUI

struct FavoriteTVShowRow: View {
  let tvShow: TVShow
  @StateObject private var favoritesManager = FavoritesManager.shared

  var body: some View {
    HStack(spacing: 12) {
      // Backdrop Image
      AsyncImage(url: tvShow.backdropURL) { phase in
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
              Image(systemName: "tv")
                .foregroundStyle(.gray)
            )
        @unknown default:
          RoundedRectangle(cornerRadius: 8)
            .fill(.gray.opacity(0.2))
            .frame(width: 120, height: 68)
        }
      }

      // TV Show Info
      VStack(alignment: .leading, spacing: 4) {
          Text(tvShow.name)
            .font(.headline)
            .lineLimit(2)


        HStack(spacing: 8) {
          if let rating = tvShow.rating {
            Image(systemName: "star.fill")
              .font(.caption)
              .foregroundStyle(.yellow)
            Text(String(format: "%.1f", rating))
              .font(.caption)
              .foregroundStyle(.secondary)
          }

          if !tvShow.firstAirDate.isEmpty {
            Text("•")
              .foregroundStyle(.secondary)
            Text(String(tvShow.firstAirDate.prefix(4)))
              .font(.caption)
              .foregroundStyle(.secondary)
          }
         
        }
        Text("TV Show")
          .font(.caption2)
          .fontWeight(.semibold)
          .foregroundStyle(.white)
          .padding(.horizontal, 6)
          .padding(.vertical, 2)
          .background(Capsule().fill(.purple))
      }

      Spacer()

      // Heart Button
      Button(action: {
        favoritesManager.toggleFavorite(tvShow)
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
  FavoriteTVShowRow(tvShow: TVShow(id: 1, name: "Sample TV Show", overview: "This is a sample TV show overview", posterPath: nil, backdropPath: nil, firstAirDate: "2024-06-15", voteAverage: 7.8, voteCount: 1000, popularity: 100.0))
}
