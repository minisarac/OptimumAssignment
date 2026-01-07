//
//  AppSettings.swift
//  OptimumAssignment
//
//  Created by Deniz Sarac on 1/6/26.
//

import Foundation
import SwiftUI
import Combine

enum AppearanceMode: String, CaseIterable {
    case light = "Light"
    case dark = "Dark"
    case auto = "Auto"
}

enum ContentType: String, CaseIterable {
    case movies = "Movies"
    case tv = "TV Shows"
    case all = "All"
}

enum SortOption: String, CaseIterable {
    case rating = "Rating (High to Low)"
    case releaseDate = "Release Date (Newest)"
    case popularity = "Popularity"
    case title = "Title (A-Z)"
}

@MainActor
class AppSettings: ObservableObject {
    static let shared = AppSettings()

    @Published var appearance: AppearanceMode {
        didSet {
            UserDefaults.standard.set(appearance.rawValue, forKey: "appearance")
        }
    }

    @Published var contentType: ContentType {
        didSet {
            UserDefaults.standard.set(contentType.rawValue, forKey: "contentType")
        }
    }

    @Published var sortOption: SortOption {
        didSet {
            UserDefaults.standard.set(sortOption.rawValue, forKey: "sortOption")
        }
    }

    private init() {
        // Load appearance
        if let savedAppearance = UserDefaults.standard.string(forKey: "appearance"),
           let mode = AppearanceMode(rawValue: savedAppearance) {
            self.appearance = mode
        } else {
            self.appearance = .auto
        }

        // Load content type
        if let savedContentType = UserDefaults.standard.string(forKey: "contentType"),
           let type = ContentType(rawValue: savedContentType) {
            self.contentType = type
        } else {
            self.contentType = .all
        }

        // Load sort option
        if let savedSortOption = UserDefaults.standard.string(forKey: "sortOption"),
           let option = SortOption(rawValue: savedSortOption) {
            self.sortOption = option
        } else {
            self.sortOption = .popularity
        }
    }

    var colorScheme: ColorScheme? {
        switch appearance {
        case .light:
            return .light
        case .dark:
            return .dark
        case .auto:
            return nil
        }
    }
}
