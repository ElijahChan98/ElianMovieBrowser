//
//  HomePageView.swift
//  SwiftUIMovieApp
//
//  Created by Elijah Tristan Huey  CHAN on 8/13/25.
//

import SwiftUI

struct HomePageView: View {
    @EnvironmentObject var favoriteMoviesModel: FavoriteMoviesModel
    @State private var path = NavigationPath()
    
    @ObservedObject var viewModel: HomeViewModel = HomeViewModel()
    @State var isPresented: Bool = false
    
    var body: some View {
        NavigationStack(path: $path) {
            VStack(spacing: 20.0) {
                titleLabel
                
                HStack {
                    Spacer()
                    searchBar
                    Spacer()
                }
                
                HStack(spacing: 12) {
                    searchButtonByName
                    favoritesButton
                }
            }
            .navigationDestination(for: String.self) { route in
                if route == "Search Results" {
                    MoviesListView(searchText: viewModel.searchText)
                }
                else if route == "Favorites" {
                    MoviesListView(movies: favoriteMoviesModel.favoriteMovies)
                }
            }
        }
        
    }
    
    var titleLabel: some View {
        Text("Elian's Movie Browser")
            .font(.largeTitle)
            .bold()
    }
    
    var searchBar: some View {
        TextField("Search Movie", text: $viewModel.searchText)
            .font(.headline)
            .textFieldStyle(.roundedBorder)
            .multilineTextAlignment(.center)
            .frame(maxWidth: 300.0)
    }
    
    var searchButtonById: some View {
        Button("Search By ID") {
            
        }
        .buttonStyle(.borderedProminent)
    }
    
    var searchButtonByName: some View {
        Button("Search By Title") {
            isPresented = false
            path.append("Search Results")
        }
        .alert("Error", isPresented: $isPresented, actions: {
            
        }, message: {
            Text("No results found")
        })
        .buttonStyle(.bordered)
        .disabled(viewModel.searchText.isEmpty)
    }
    
    var favoritesButton: some View {
        Button("Favorites") {
            path.append("Favorites")
        }
        .buttonStyle(.bordered)
    }
    
}

#Preview {
    HomePageView()
        .environmentObject(FavoriteMoviesModel())
}
