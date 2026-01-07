//
//  ListRowView.swift
//  OptimumAssignment
//
//  Created by Deniz Sarac on 1/5/26.
//

import SwiftUI

struct ListRowView: View {
  
  let movie: Movie
  
    var body: some View {
      HStack(spacing: 12) {
        RoundedRectangle(cornerRadius: 8)
          .fill(.gray.opacity(0.2))
          .frame(width: 44, height: 66)
          .overlay(
            Image(systemName: "film")
              .foregroundStyle(.gray)
          )
        
        Text(movie.title)
          .font(.headline)
          .lineLimit(2)
        
        Spacer()
      }
      .padding(.vertical, 4)

    }
}

#Preview {
//  ListRowView(movie: StubMovies.trendingThisWeek[1])
}
