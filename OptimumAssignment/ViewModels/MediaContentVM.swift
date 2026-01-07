//
//  MediaContentVM.swift
//  OptimumAssignment
//
//  Created by Deniz Sarac on 1/6/26.
//

import Combine
import Foundation

@MainActor
class MediaContentVM: ObservableObject {
    @Published var isLoading = false
    @Published var errorMessage: String?

    @Published var period: TrendingPeriod = .day
    @Published var movies: [MediaContent] = []
    @Published var tvShows: [MediaContent] = []

    func content(for type: MediaType) -> [MediaContent] {
        type == .movie ? movies : tvShows
    }

    var subscriptions = Set<AnyCancellable>()

    private let settings = AppSettings.shared
    private let networkManager = NetworkManager.shared

    init() {
        addListeners()
    }

    func addListeners() {
        Publishers.CombineLatest(
            settings.$contentType,
            $period
        )
        .sink { [weak self] contentType, period in
            switch contentType {
            case .movies:
                self?.fetch(.movie, period: period)
            case .tv:
                self?.fetch(.tv, period: period)
            case .all:
                self?.fetch(.movie, period: period)
                self?.fetch(.tv, period: period)
            }
        }
        .store(in: &subscriptions)
    }

    func fetch(_ type: MediaType, period: TrendingPeriod) {
        isLoading = true
        errorMessage = nil

        Task {
            do {
                let content = try await networkManager.fetchTrending(type, period: period)
                isLoading = false
                if type == .movie {
                    movies = content.results
                } else {
                    tvShows = content.results
                }
            } catch {
                isLoading = false
                errorMessage = error.localizedDescription
            }
        }
    }
}
