//
//  TVShowCardView.swift
//  OptimumAssignment
//
//  Created by Deniz Sarac on 1/6/26.
//

import SwiftUI

struct TVShowCardView: View {
  let tvShow: TVShow
  @StateObject private var favoritesManager = FavoritesManager.shared

  var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      ZStack(alignment: .topTrailing) {
        AsyncImage(url: tvShow.posterURL) { phase in
        switch phase {
        case .empty:
          RoundedRectangle(cornerRadius: 12)
            .fill(.gray.opacity(0.2))
            .aspectRatio(2/3, contentMode: .fit)
            .overlay(
              ProgressView()
            )
        case .success(let image):
          image
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(maxWidth: .infinity)
            .aspectRatio(2/3, contentMode: .fit)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        case .failure:
          RoundedRectangle(cornerRadius: 12)
            .fill(.gray.opacity(0.2))
            .aspectRatio(2/3, contentMode: .fit)
            .overlay(
              Image(systemName: "tv")
                .font(.system(size: 28))
                .foregroundStyle(.gray)
            )
        @unknown default:
          RoundedRectangle(cornerRadius: 12)
            .fill(.gray.opacity(0.2))
            .aspectRatio(2/3, contentMode: .fit)
        }
      }

      Button(action: {
        favoritesManager.toggleFavorite(tvShow)
      }) {
        Image(systemName: favoritesManager.isFavorite(tvShow) ? "heart.fill" : "heart")
          .font(.system(size: 20))
          .foregroundStyle(favoritesManager.isFavorite(tvShow) ? .red : .white)
          .padding(8)
          .background(Circle().fill(.black.opacity(0.5)))
      }
      .padding(8)
    }

      Text(tvShow.name)
        .font(.headline)
        .lineLimit(2)
        .fixedSize(horizontal: false, vertical: true)
        .frame(minHeight: 44, alignment: .top)
        .multilineTextAlignment(.leading)

      HStack(spacing: 6) {
        if let rating = tvShow.rating {
          Image(systemName: "star.fill")
            .font(.caption)
            .foregroundStyle(.yellow)
          Text(String(format: "%.1f", rating))
            .font(.caption)
            .foregroundStyle(.secondary)
        }

        Spacer()

        if !tvShow.firstAirDate.isEmpty {
          Text(String(tvShow.firstAirDate.prefix(4)))
            .font(.caption)
            .foregroundStyle(.secondary)
        }
      }
      .foregroundStyle(.secondary)
    }
    .padding(10)
    .background(
      RoundedRectangle(cornerRadius: 16)
        .fill(.background)
        .shadow(radius: 2, y: 1)
    )

  }
}

#Preview {
  TVShowCardView(tvShow: TVShow(id: 1, name: "Sample TV Show", overview: "This is a sample TV show overview", posterPath: nil, backdropPath: nil, firstAirDate: "2024-06-15", voteAverage: 7.8, voteCount: 1000, popularity: 100.0))
}
