//
//  HomeAltView.swift
//  OptimumAssignment
//
//  Created by Deniz Sarac on 1/5/26.
//

import SwiftUI

struct HomeAltView: View {

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

  private let columns = [
    GridItem(.flexible(), spacing: 12),
    GridItem(.flexible(), spacing: 12)
  ]

  var isShowingMovies: Bool {
    settings.contentType == .movies
  }

  var isShowingTV: Bool {
    settings.contentType == .tv
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
        .padding([.horizontal, .bottom])
        .onChange(of: period) { newValue in
          Task {
            if isShowingMovies {
              await movieViewModel.loadTrendingMovies(timeWindow: timeWindow)
            } else if isShowingTV {
              await tvViewModel.loadTrendingTVShows(timeWindow: timeWindow)
            }
          }
        }

        if isShowingMovies {
          // Movies Grid
          if movieViewModel.isLoading {
            ProgressView()
              .frame(maxWidth: .infinity, maxHeight: .infinity)
          } else if let error = movieViewModel.errorMessage {
            Text(error)
              .foregroundColor(.red)
              .padding()
          } else {
            ScrollView {
              LazyVGrid(columns: columns, spacing: 12) {
                ForEach(movieViewModel.movies.sorted(by: settings.sortOption)) { movie in
                  NavigationLink {
                    MovieDetailsView(movie: movie)
                  } label: {
                    MovieCardView(movie: movie)
                  }
                  .buttonStyle(.plain)
                }
              }
              .padding(.horizontal)
              .padding(.top, 8)
            }
          }
        } else if isShowingTV {
          // TV Shows Grid
          if tvViewModel.isLoading {
            ProgressView()
              .frame(maxWidth: .infinity, maxHeight: .infinity)
          } else if let error = tvViewModel.errorMessage {
            Text(error)
              .foregroundColor(.red)
              .padding()
          } else {
            ScrollView {
              LazyVGrid(columns: columns, spacing: 12) {
                ForEach(tvViewModel.tvShows.sorted(by: settings.sortOption)) { tvShow in
                  NavigationLink {
                    TVShowDetailsView(tvShow: tvShow)
                  } label: {
                    TVShowCardView(tvShow: tvShow)
                  }
                  .buttonStyle(.plain)
                }
              }
              .padding(.horizontal)
              .padding(.top, 8)
            }
          }
        }
      }
      .navigationTitle(isShowingMovies ? "Movies" : "TV Shows")
      .task {
        if isShowingMovies {
          await movieViewModel.loadTrendingMovies(timeWindow: timeWindow)
        } else if isShowingTV {
          await tvViewModel.loadTrendingTVShows(timeWindow: timeWindow)
        }
      }
    }
  }
}

#Preview {
  HomeAltView()
}
