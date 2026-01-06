//
//  HomeAltView.swift
//  OptimumAssignment
//
//  Created by Deniz Sarac on 1/5/26.
//

import SwiftUI

struct HomeAltView: View {
  
  @State private var period: TrendingPeriod = .today
  
  private var movies: [Movie] {
    switch period {
    case .today:
      StubMovies.trendingToday
    case .thisWeek:
      StubMovies.trendingThisWeek
    }
  }
  
  private let columns = [
    GridItem(.flexible(), spacing: 12),
    GridItem(.flexible(), spacing: 12)
  ]
  
  var body: some View {
    NavigationStack {
        Picker("Trending Period", selection: $period) {
          ForEach(TrendingPeriod.allCases, id: \.rawValue) { item in
            Text(item.rawValue).tag(item)
          }
        }
        .pickerStyle(.segmented)
        .padding(.horizontal)
        
        ScrollView {
          LazyVGrid(columns: columns, spacing: 12) {
            ForEach(movies) { movie in
              NavigationLink {
                MovieDetailsView(movie: movie)
              } label: {
                MovieCardView(movie: movie)
//                  .frame(width: 180)
              }
            }
          }
          .padding(.horizontal)
          .padding(.top, 8)
        }
      .navigationTitle("Trending")
    }
  }
}

#Preview {
  HomeAltView()
}
