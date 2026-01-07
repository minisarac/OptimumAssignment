//
//  HomeView.swift
//  OptimumAssignment
//
//  Created by Deniz Sarac on 1/5/26.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var listViewModel: MediaContentVM
    @StateObject private var settings = AppSettings.shared

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Picker("Trending Period", selection: $listViewModel.period) {
                    ForEach(TrendingPeriod.allCases, id: \.rawValue) { item in
                        Text(item.label).tag(item)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                .padding(.bottom, 8)

                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        switch settings.contentType {
                        case .all:
                            mediaSection(for: .movie)
                            mediaSection(for: .tv)

                        case .tv:
                            mediaSection(for: .tv)

                        case .movies:
                            mediaSection(for: .movie)
                        }
                    }
                    .padding(.top, 8)
                }
            }
            .navigationTitle("Most Popular")
        }
    }

    func mediaSection(for mediaType: MediaType) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(mediaType.title)
                .font(.title2)
                .fontWeight(.bold)
                .padding(.horizontal)

            if listViewModel.isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity)
                    .frame(height: 200)
            } else if let error = listViewModel.errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .padding(.horizontal)
            } else if settings.contentType != .all {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 8) {
                        carouselContent(for: mediaType)
                    }
                    .padding(.horizontal)
                    .padding(.top, 8)
                }
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 12) {
                        carouselContent(for: mediaType)
                    }
                    .padding(.horizontal)
                }
            }
        }
    }

    func carouselContent(for mediaType: MediaType) -> some View {
        ForEach(sortedContent(for: mediaType)) { media in
            NavigationLink {
                MediaDetailsView(media: media)
            } label: {
                CardView(media: media)
                    .frame(width: settings.contentType == .all ? 150 : 180)
                    .padding(.vertical)
            }
            .buttonStyle(.plain)
        }
    }

    func sortedContent(for mediaType: MediaType) -> [MediaContent] {
        switch settings.sortOption {
        case .rating:
            return listViewModel.content(for: mediaType).sorted { $0.voteAverage > $1.voteAverage }
        case .releaseDate:
            return listViewModel.content(for: mediaType).sorted { $0.year ?? "" > $1.year ?? "" }
        case .popularity:
            return listViewModel.content(for: mediaType).sorted { $0.popularity > $1.popularity }
        case .title:
            return listViewModel.content(for: mediaType).sorted { $0.contentTitle < $1.contentTitle }
        }
    }

    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12),
    ]
}

#Preview {
    HomeView()
}
