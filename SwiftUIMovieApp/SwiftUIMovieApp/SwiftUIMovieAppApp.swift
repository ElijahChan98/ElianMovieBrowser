//
//  SwiftUIMovieAppApp.swift
//  SwiftUIMovieApp
//
//  Created by Elijah Tristan Huey  CHAN on 8/13/25.
//

import SwiftUI
import SwiftData
import Combine

@main
struct SwiftUIMovieAppApp: App {
    @StateObject var favoriteMoviesModel = FavoriteMoviesModel()
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    var body: some Scene {
        WindowGroup {
            HomePageView()
                .environmentObject(favoriteMoviesModel)
        }
        .modelContainer(sharedModelContainer)
    }
}
