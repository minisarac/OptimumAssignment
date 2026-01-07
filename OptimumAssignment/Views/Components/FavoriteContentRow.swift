//
//  FavoriteContentRow.swift
//  OptimumAssignment
//
//  Created by Deniz Sarac on 1/6/26.
//

import Kingfisher
import SwiftUI

struct FavoriteContentRow: View {
    let media: MediaContent
    @StateObject private var favoritesManager = FavoritesManager.shared

    var body: some View {
        HStack(spacing: 12) {
            // Backdrop Image
            KFImage(media.backdropURL)
                .placeholder {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(.gray.opacity(0.2))
                        .frame(width: 120, height: 68)
                        .overlay(
                            ProgressView()
                        )
                }
                .onFailureView {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(.gray.opacity(0.2))
                        .frame(width: 120, height: 68)
                        .overlay {
                            Image(systemName: media.mediaType == .movie ? "film" : "tv")
                                .foregroundStyle(.gray)
                        }
                }
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 120, height: 68)
                .clipShape(RoundedRectangle(cornerRadius: 8))

            // Media Info
            VStack(alignment: .leading, spacing: 4) {
                Text(media.contentTitle)
                    .font(.headline)
                    .lineLimit(2)

                HStack(spacing: 8) {
                    Image(systemName: "star.fill")
                        .font(.caption)
                        .foregroundStyle(.yellow)
                    Text(String(format: "%.1f", media.voteAverage))
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    if let year = media.year {
                        Text("•")
                            .foregroundStyle(.secondary)
                        Text(year)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }

                Text(media.mediaType.title.dropLast())
                    .font(.caption2)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(Capsule().fill(media.mediaType == .movie ? .blue : .purple))
            }

            Spacer()

            // Heart Button
            Button(action: {
                favoritesManager.toggleFavorite(media)
            }) {
                Image(systemName: "heart.fill")
                    .font(.system(size: 20))
                    .foregroundStyle(.red)
            }
            .buttonStyle(.plain)
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    FavoriteContentRow(media: MediaContentStubs.tvShow1)
}
