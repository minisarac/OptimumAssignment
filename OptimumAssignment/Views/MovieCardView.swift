//
//  MovieCardView.swift
//  OptimumAssignment
//
//  Created by Deniz Sarac on 1/5/26.
//

import SwiftUI

struct MovieCardView: View {
  let movie: Movie
  @StateObject private var favoritesManager = FavoritesManager.shared

  var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      ZStack(alignment: .topTrailing) {
        AsyncImage(url: movie.posterURL) { phase in
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
              Image(systemName: "film")
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
        favoritesManager.toggleFavorite(movie)
      }) {
        Image(systemName: favoritesManager.isFavorite(movie) ? "heart.fill" : "heart")
          .font(.system(size: 20))
          .foregroundStyle(favoritesManager.isFavorite(movie) ? .red : .white)
          .padding(8)
          .background(Circle().fill(.black.opacity(0.5)))
      }
      .padding(8)
    }

      Text(movie.title)
        .font(.headline)
        .lineLimit(2)
        .fixedSize(horizontal: false, vertical: true)
        .frame(minHeight: 44, alignment: .top)
        .multilineTextAlignment(.leading)
      
      HStack(spacing: 6) {
        if let rating = movie.rating {
          Image(systemName: "star.fill")
            .font(.caption)
          Text(String(format: "%.1f", rating))
            .font(.caption)
        }
        
        Spacer()
        
        if !movie.releaseDate.isEmpty {
          Text(String(movie.releaseDate.prefix(4)))
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
  MovieCardView(movie: Movie(id: 1, title: "Sample Movie Title", overview: "This is a sample movie overview", posterPath: nil, backdropPath: nil, releaseDate: "2024-06-15", voteAverage: 7.8, voteCount: 1000, popularity: 100.0))
}
