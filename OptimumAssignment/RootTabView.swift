//
//  ContentView.swift
//  OptimumAssignment
//
//  Created by Deniz Sarac on 1/5/26.
//

import SwiftUI

struct RootTabView: View {
    var body: some View {
      TabView {
        HomeView()
          .tabItem {
            Label("Home", systemImage: "house")
          }
        
        HomeAltView()
          .tabItem {
            Label("Alternative", systemImage: "house")
          }
        
        
        FavoritesView()
          .tabItem {
            Label("Favorites", systemImage: "heart")
          }
        
        
        SettingsView()
          .tabItem {
            Label("Settings", systemImage: "gear")
          }
        
      }
      
    }
}

#Preview {
    RootTabView()
}
