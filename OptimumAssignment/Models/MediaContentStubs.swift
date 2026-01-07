//
//  MediaContentStubs.swift
//  OptimumAssignment
//
//  Created by Deniz Sarac on 1/5/26.
//

import Foundation

enum MediaContentStubs {
    // MARK: - Movies

    static let movie1 = MediaContent(
        id: 1001,
        name: nil,
        title: "Quantum Horizon",
        overview: "A physicist discovers a way to traverse parallel universes, but each jump brings him closer to a reality where humanity never existed. Racing against time, he must find his way home before he loses himself completely.",
        posterPath: "/sample1.jpg",
        backdropPath: "/backdrop1.jpg",
        releaseDate: "2024-03-15",
        firstAirDate: nil,
        voteAverage: 8.2,
        voteCount: 2847,
        popularity: 156.8,
        mediaType: .movie
    )

    static let movie2 = MediaContent(
        id: 1002,
        name: nil,
        title: "The Last Lighthouse",
        overview: "In a coastal town threatened by rising seas, a reclusive lighthouse keeper befriends a young environmental activist. Together, they uncover a century-old secret that could save their community.",
        posterPath: "/sample2.jpg",
        backdropPath: "/backdrop2.jpg",
        releaseDate: "2023-11-08",
        firstAirDate: nil,
        voteAverage: 7.6,
        voteCount: 1523,
        popularity: 92.4,
        mediaType: .movie
    )

    static let movie3 = MediaContent(
        id: 1003,
        name: nil,
        title: "Midnight Café",
        overview: "A quirky all-night diner becomes the backdrop for intersecting stories of love, loss, and second chances. With a colorful cast of regulars and one very particular waitress, magic happens between the hours of midnight and dawn.",
        posterPath: "/sample3.jpg",
        backdropPath: "/backdrop3.jpg",
        releaseDate: "2024-01-22",
        firstAirDate: nil,
        voteAverage: 7.1,
        voteCount: 892,
        popularity: 45.2,
        mediaType: .movie
    )

    // MARK: - TV Shows

    static let tvShow1 = MediaContent(
        id: 2001,
        name: "Neon Underground",
        title: nil,
        overview: "In a cyberpunk metropolis, a hacker collective fights against corporate surveillance while navigating personal betrayals and dangerous AI. Each episode peels back another layer of conspiracy in this neon-soaked thriller.",
        posterPath: "/tv1.jpg",
        backdropPath: "/tvbackdrop1.jpg",
        releaseDate: nil,
        firstAirDate: "2023-09-18",
        voteAverage: 8.7,
        voteCount: 4562,
        popularity: 203.5,
        mediaType: .tv
    )

    static let tvShow2 = MediaContent(
        id: 2002,
        name: "The Cartographers",
        title: nil,
        overview: "A family of map makers discovers that their antique maps reveal hidden places that shouldn't exist. As they explore these impossible locations, they uncover secrets that connect their family's past to an ancient mystery.",
        posterPath: "/tv2.jpg",
        backdropPath: "/tvbackdrop2.jpg",
        releaseDate: nil,
        firstAirDate: "2024-02-05",
        voteAverage: 7.9,
        voteCount: 2134,
        popularity: 128.6,
        mediaType: .tv
    )

    static let tvShow3 = MediaContent(
        id: 2003,
        name: "Precinct 47",
        title: nil,
        overview: "A mockumentary following the daily chaos of the city's most dysfunctional police precinct. With incompetent detectives, bizarre cases, and one very tired captain, nothing ever goes according to plan.",
        posterPath: "/tv3.jpg",
        backdropPath: "/tvbackdrop3.jpg",
        releaseDate: nil,
        firstAirDate: "2023-08-12",
        voteAverage: 8.3,
        voteCount: 3891,
        popularity: 167.2,
        mediaType: .tv
    )

    // MARK: - Collections

    static let allMovies = [movie1, movie2, movie3]
    static let allTVShows = [tvShow1, tvShow2, tvShow3]
    static let allContent = allMovies + allTVShows
}
