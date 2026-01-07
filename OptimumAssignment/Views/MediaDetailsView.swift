//
//  MediaDetailsView.swift
//  OptimumAssignment
//
//  Created by Deniz Sarac on 1/7/26.
//

import Kingfisher
import SwiftUI

struct MediaDetailsView: View {
    let media: MediaContent
    @StateObject private var favoritesManager = FavoritesManager.shared
    @State private var movieDetail: MovieDetail?
    @State private var tvDetail: TVShowDetail?
    @State private var isLoading = false
    @State private var errorMessage: String?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Backdrop Image
                KFImage(media.backdropURL)
                    .placeholder {
                        RoundedRectangle(cornerRadius: 0)
                            .fill(.gray.opacity(0.2))
                            .frame(maxWidth: .infinity)
                            .aspectRatio(16 / 9, contentMode: .fit)
                            .overlay(
                                ProgressView()
                            )
                    }
                    .onFailureView {
                        RoundedRectangle(cornerRadius: 0)
                            .fill(.gray.opacity(0.2))
                            .frame(maxWidth: .infinity)
                            .aspectRatio(16 / 9, contentMode: .fit)
                            .overlay {
                                Image(systemName: media.mediaType == .movie ? "film" : "tv")
                                    .font(.system(size: 44))
                                    .foregroundStyle(.gray)
                            }
                    }
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(maxWidth: .infinity)
                    .aspectRatio(16 / 9, contentMode: .fit)
                    .clipped()

                VStack(alignment: .leading, spacing: 8) {
                    // Title
                    Text(media.contentTitle)
                        .font(.title2)
                        .fontWeight(.semibold)

                    // Rating
                    HStack(spacing: 6) {
                        Image(systemName: "star.fill")
                            .foregroundStyle(.yellow)
                        Text(String(format: "%.1f", media.voteAverage))
                    }
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                    Divider().padding(.vertical, 8)

                    if isLoading {
                        ProgressView()
                            .frame(maxWidth: .infinity)
                    } else if let error = errorMessage {
                        Text(error)
                            .foregroundColor(.red)
                            .font(.caption)
                    } else {
                        // Overview Section
                        Text("Overview")
                            .font(.headline)

                        Text(media.overview)
                            .font(.body)
                            .foregroundStyle(.secondary)

                        Divider().padding(.vertical, 8)

                        // Details Section
                        let genres: [Genre] = {
                            if let movieDetail = movieDetail {
                                return movieDetail.genres
                            } else if let tvDetail = tvDetail {
                                return tvDetail.genres
                            }
                            return []
                        }()

                        let runtime: Int? = movieDetail?.runtime ?? tvDetail?.runtime
                        let certification: String? = movieDetail?.certification ?? tvDetail?.certification
                        let directorOrCreator: String? = movieDetail?.director ?? tvDetail?.creator

                        VStack(alignment: .leading, spacing: 12) {
                            if let certification = certification, !certification.isEmpty {
                                DetailRow(label: "Rating", value: certification)
                            }

                            if let date = media.mediaType == .movie ? media.releaseDate : media.firstAirDate, !date.isEmpty {
                                DetailRow(
                                    label: media.mediaType == .movie ? "Release Date" : "First Air Date",
                                    value: date
                                )
                            }

                            if !genres.isEmpty {
                                DetailRow(label: "Genres", value: genres.map { $0.name }.joined(separator: ", "))
                            }

                            if let runtime = runtime {
                                if media.mediaType == .movie {
                                    let hours = runtime / 60
                                    let minutes = runtime % 60
                                    DetailRow(label: "Runtime", value: "\(hours)h \(minutes)m")
                                } else {
                                    DetailRow(label: "Episode Runtime", value: "\(runtime) min")
                                }
                            }

                            if let directorOrCreator = directorOrCreator {
                                DetailRow(
                                    label: media.mediaType == .movie ? "Director" : "Creator",
                                    value: directorOrCreator
                                )
                            }
                        }
                    }
                }
                .padding(.horizontal)
            }
            .padding(.top)
        }
        .navigationTitle("Details")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    favoritesManager.toggleFavorite(media)
                } label: {
                    Image(systemName: favoritesManager.isFavorite(media) ? "heart.fill" : "heart")
                        .foregroundStyle(favoritesManager.isFavorite(media) ? .red : .primary)
                }
            }
        }
        .task {
            await loadDetails()
        }
    }

    func loadDetails() async {
        isLoading = true
        errorMessage = nil

        do {
            if media.mediaType == .movie {
                movieDetail = try await NetworkManager.shared.fetchMovieDetails(movieId: media.id)
            } else {
                tvDetail = try await NetworkManager.shared.fetchTVShowDetails(tvShowId: media.id)
            }
        } catch {
            errorMessage = "Failed to load details"
            print("DEBUG: Error loading details: \(error)")
        }

        isLoading = false
    }
}

struct DetailRow: View {
    let label: String
    let value: String

    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Text(label + ":")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundStyle(.primary)
                .frame(width: 100, alignment: .leading)

            Text(value)
                .font(.subheadline)
                .foregroundStyle(.secondary)

            Spacer()
        }
    }
}

#Preview {
    NavigationStack {
        MediaDetailsView(media: MediaContentStubs.movie2)
    }
}
