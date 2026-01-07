//
//  HomeView.swift
//  OptimumAssignment
//
//  Created by Deniz Sarac on 1/5/26.
//

import SwiftUI

struct HomeView: View {
  @StateObject private var movieViewModel = MovieListViewModel()
  @StateObject private var tvViewModel = TVShowListViewModel()
  @StateObject private var settings = AppSettings.shared
  @State private var period: TrendingPeriod = .today

  private var timeWindow: String {
    switch period {
    case .today: return "day"
    case .thisWeek: return "week"
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
        .padding(.bottom, 8)
        .onChange(of: period) { newValue in
          Task {
            await movieViewModel.loadTrendingMovies(timeWindow: timeWindow)
            await tvViewModel.loadTrendingTVShows(timeWindow: timeWindow)
          }
        }

        ScrollView {
          VStack(alignment: .leading, spacing: 20) {
            // Movies Section
            VStack(alignment: .leading, spacing: 12) {
              Text("Movies")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.horizontal)

              if movieViewModel.isLoading {
                ProgressView()
                  .frame(maxWidth: .infinity)
                  .frame(height: 200)
              } else if let error = movieViewModel.errorMessage {
                Text(error)
                  .foregroundColor(.red)
                  .padding(.horizontal)
              } else {
                ScrollView(.horizontal, showsIndicators: false) {
                  LazyHStack(spacing: 12) {
                    ForEach(movieViewModel.movies.sorted(by: settings.sortOption)) { movie in
                      NavigationLink {
                        MovieDetailsView(movie: movie)
                      } label: {
                        MovieCardView(movie: movie)
                          .frame(width: 150)
                      }
                      .buttonStyle(.plain)
                    }
                  }
                  .padding(.horizontal)
                }
              }
            }

            // TV Shows Section
            VStack(alignment: .leading, spacing: 12) {
              Text("TV Shows")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.horizontal)

              if tvViewModel.isLoading {
                ProgressView()
                  .frame(maxWidth: .infinity)
                  .frame(height: 200)
              } else if let error = tvViewModel.errorMessage {
                Text(error)
                  .foregroundColor(.red)
                  .padding(.horizontal)
              } else {
                ScrollView(.horizontal, showsIndicators: false) {
                  LazyHStack(spacing: 12) {
                    ForEach(tvViewModel.tvShows.sorted(by: settings.sortOption)) { tvShow in
                      NavigationLink {
                        TVShowDetailsView(tvShow: tvShow)
                      } label: {
                        TVShowCardView(tvShow: tvShow)
                          .frame(width: 150)
                      }
                      .buttonStyle(.plain)
                    }
                  }
                  .padding(.horizontal)
                }
              }
            }
          }
          .padding(.top, 8)
        }
      }
      .navigationTitle("Trending")
      .task {
        await movieViewModel.loadTrendingMovies(timeWindow: timeWindow)
        await tvViewModel.loadTrendingTVShows(timeWindow: timeWindow)
      }
    }
  }
}


#Preview {
  HomeView()
}
