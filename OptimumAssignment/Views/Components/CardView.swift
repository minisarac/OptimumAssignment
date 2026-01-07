//
//  CardView.swift
//  OptimumAssignment
//
//  Created by Deniz Sarac on 1/5/26.
//

import Kingfisher
import SwiftUI

struct CardView: View {
    let media: MediaContent
    @StateObject private var favoritesManager = FavoritesManager.shared

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack(alignment: .topTrailing) {
                KFImage(media.posterURL)
                    .placeholder {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.gray.opacity(0.2))
                            .aspectRatio(2 / 3, contentMode: .fit)
                            .overlay(
                                ProgressView()
                            )
                    }
                    .onFailureView {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.gray.opacity(0.2))
                            .aspectRatio(2 / 3, contentMode: .fit)
                            .overlay {
                                Image(systemName: "film")
                                    .font(.system(size: 28))
                                    .foregroundStyle(.gray)
                            }
                    }
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(maxWidth: .infinity)
                    .aspectRatio(2 / 3, contentMode: .fit)
                    .clipShape(RoundedRectangle(cornerRadius: 12))

                Button(action: {
                    favoritesManager.toggleFavorite(media)
                }) {
                    Image(systemName: favoritesManager.isFavorite(media) ? "heart.fill" : "heart")
                        .font(.system(size: 20))
                        .foregroundStyle(favoritesManager.isFavorite(media) ? .red : .white)
                        .padding(8)
                        .background(Circle().fill(.black.opacity(0.5)))
                }
                .padding(8)
            }

            Text(media.contentTitle)
                .font(.headline)
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)
                .frame(minHeight: 44, alignment: .top)
                .multilineTextAlignment(.leading)

            HStack(spacing: 6) {
                Image(systemName: "star.fill")
                    .font(.caption)
                Text(String(format: "%.1f", media.voteAverage))
                    .font(.caption)

                Spacer()

                if let year = media.year {
                    Text(year)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .foregroundStyle(.secondary)
        }
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.background)
                .shadow(radius: 2, y: 1)
        )
    }
}

#Preview {
    CardView(media: MediaContentStubs.movie1)
}
