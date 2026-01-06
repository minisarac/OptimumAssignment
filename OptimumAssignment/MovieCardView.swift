//
//  MovieCardView.swift
//  OptimumAssignment
//
//  Created by Deniz Sarac on 1/5/26.
//

import SwiftUI

struct MovieCardView: View {
  let movie: Movie
  
  var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      ZStack {
        RoundedRectangle(cornerRadius: 12)
          .fill(.gray.opacity(0.2))
          .aspectRatio(2/3, contentMode: .fit)
        
        Image(systemName: "film")
          .font(.system(size: 28))
          .foregroundStyle(.gray)
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
        
        if let releaseDate = movie.releaseDate, !releaseDate.isEmpty {
          Text(String(releaseDate.prefix(4)))
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
  MovieCardView(movie: StubMovies.trendingThisWeek[1])
}
