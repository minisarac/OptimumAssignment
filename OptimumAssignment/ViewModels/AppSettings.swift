//
//  AppSettings.swift
//  OptimumAssignment
//
//  Created by Deniz Sarac on 1/6/26.
//

import Combine
import Foundation
import SwiftUI

enum AppearanceMode: String, CaseIterable {
    case light = "Light"
    case dark = "Dark"
    case auto = "Auto"
}

enum ContentType: String, CaseIterable, Codable {
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
        if let savedAppearance = UserDefaults.standard.string(forKey: "appearance"),
           let mode = AppearanceMode(rawValue: savedAppearance)
        {
            appearance = mode
        } else {
            appearance = .auto
        }

        if let savedContentType = UserDefaults.standard.string(forKey: "contentType"),
           let type = ContentType(rawValue: savedContentType)
        {
            contentType = type
        } else {
            contentType = .all
        }

        if let savedSortOption = UserDefaults.standard.string(forKey: "sortOption"),
           let option = SortOption(rawValue: savedSortOption)
        {
            sortOption = option
        } else {
            sortOption = .popularity
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
