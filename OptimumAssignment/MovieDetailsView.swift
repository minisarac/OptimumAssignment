//
//  MovieDetailsView.swift
//  OptimumAssignment
//
//  Created by Deniz Sarac on 1/5/26.
//

import SwiftUI

struct MovieDetailsView: View {
  let movie: Movie
  
    var body: some View {
     
      ScrollView {
        VStack(alignment: .leading, spacing: 16) {
          
          RoundedRectangle(cornerRadius: 16)
            .fill(.gray.opacity(0.2))
            .frame(maxWidth: .infinity)
            .aspectRatio(2/3, contentMode: .fit)
            .overlay(
              Image(systemName: "film")
                .font(.system(size: 44))
                .foregroundStyle(.gray)
            )
            .padding(.horizontal)
          
          VStack(alignment: .leading, spacing: 8) {
            Text(movie.title)
              .font(.title2)
              .fontWeight(.semibold)
            
            HStack(spacing: 10) {
              if let rating = movie.rating {
                Label(String(format: "%.1f", rating), systemImage: "star.fill")
              }
              if let date = movie.releaseDate, !date.isEmpty {
                Text(date)
              }
            }
            .font(.subheadline)
            .foregroundStyle(.secondary)
            
            Divider().padding(.vertical, 8)
            
            Text("Overview")
              .font(.headline)
            
            Text("This is the stub text")
              .font(.body)
              .foregroundStyle(.secondary)
          }
          .padding(.horizontal)
          
          
        }
        .padding(.top)
      }
      .navigationTitle("Details")
      .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
  MovieDetailsView(movie: StubMovies.trendingThisWeek[1])
}
