//
//  RootTabView.swift
//  OptimumAssignment
//
//  Created by Deniz Sarac on 1/5/26.
//

import SwiftUI

struct RootTabView: View {
    @StateObject private var settings = AppSettings.shared
    @StateObject private var listViewModel = MediaContentVM()

    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }

            FavoritesView()
                .tabItem {
                    Label("Favorites", systemImage: "heart.fill")
                }

            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
        .preferredColorScheme(settings.colorScheme)
        .environmentObject(listViewModel)
    }
}

#Preview {
    RootTabView()
}
