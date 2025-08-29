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
    @State var isShowingDropdown: Bool = false
    
    @State var selectedMovie: Movie?
    
    var body: some View {
        NavigationStack(path: $path) {
            ZStack {
                if isShowingDropdown {
                    Color(.black).opacity(0.05)
                        .ignoresSafeArea()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .onTapGesture {
                            isShowingDropdown = false
                        }
                }
                
                VStack(spacing: 20.0) {
                    titleLabel
                    
                    HStack {
                        Spacer()
                        SearchFieldWithDropdown(searchText: $viewModel.searchText, isShowingDropdown: $isShowingDropdown) { movie in
                            self.selectedMovie = movie
                        }
                        Spacer()
                    }
                    
                    HStack(spacing: 12) {
                        if !isShowingDropdown {
                            searchButtonByName
                            favoritesButton
                        }
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
        .sheet(item: $selectedMovie) { movie in
            MovieDetailsView(viewModel: MovieDetailsViewModel(movie: movie))
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
