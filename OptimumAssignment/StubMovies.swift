//
//  StubMovies.swift
//  OptimumAssignment
//
//  Created by Deniz Sarac on 1/5/26.
//

import Foundation

enum StubMovies {
  static let trendingToday: [Movie] = [
    Movie(id: 101, title: "Pastel Horizon", posterPath: nil, releaseDate: "2024-06-14", rating: 7.8),
    Movie(id: 102, title: "Neon Orchard", posterPath: nil, releaseDate: "2023-11-02", rating: 6.9),
    Movie(id: 103, title: "Atlas of Dreams", posterPath: nil, releaseDate: "2022-03-18", rating: 8.2),
    Movie(id: 104, title: "Midnight Ferry", posterPath: nil, releaseDate: "2021-09-30", rating: 7.1),
    Movie(id: 105, title: "Paper Moons", posterPath: nil, releaseDate: "2020-01-08", rating: 6.5),
    Movie(id: 106, title: "Golden Hour", posterPath: nil, releaseDate: "2019-07-21", rating: 7.9)
  ]
  
  static let trendingThisWeek: [Movie] = [
    Movie(id: 201, title: "The Quiet Circuit", posterPath: nil, releaseDate: "2024-02-10", rating: 8.0),
    Movie(id: 202, title: "Cobalt City", posterPath: nil, releaseDate: "2023-05-05", rating: 7.3),
    Movie(id: 203, title: "Aster & Ash", posterPath: nil, releaseDate: "2022-12-19", rating: 6.8),
    Movie(id: 204, title: "Velvet Skyline", posterPath: nil, releaseDate: "2021-04-27", rating: 7.6)
  ]
  
}
