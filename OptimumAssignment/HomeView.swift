//
//  HomeView.swift
//  OptimumAssignment
//
//  Created by Deniz Sarac on 1/5/26.
//

import SwiftUI

struct HomeView: View {
  @State private var period: TrendingPeriod = .today
  
  private var movies: [Movie] {
    switch period {
    case .today:
      StubMovies.trendingToday
    case .thisWeek:
      StubMovies.trendingThisWeek
    }
  }
  
  
  var body: some View {
    NavigationStack {
      VStack(spacing: 0) {
        Picker("Trending Period", selection: $period) {
          ForEach(TrendingPeriod.allCases, id: \.rawValue) { item in
            Text(item.rawValue).tag(item)
          }
        }
        .pickerStyle(.segmented)
        .padding(.horizontal)

        ScrollView(.horizontal, showsIndicators: true) {
          LazyHStack(spacing: 12) {
            ForEach(movies) { movie in
              MovieCardView(movie: movie)
                .frame(width: 150)
            }
          }
          .padding(.horizontal)
        }

      }
      .navigationTitle("Trending")
    }
    
  }
}


#Preview {
  HomeView()
}
