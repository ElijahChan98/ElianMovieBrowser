//
//  MoviesListView.swift
//  SwiftUIMovieApp
//
//  Created by Elijah Tristan Huey  CHAN on 8/13/25.
//

import SwiftUI

struct MoviesListView: View {
    @State var searchText: String = ""
    @State var movies: [Movie]?
    @StateObject private var viewModel = MoviesListViewModel()
    
    @State var selectedMovie: Movie?
    
    var body: some View {
        Group {
            if viewModel.isLoading {
                loadingView
            } else if !viewModel.movies.isEmpty {
                moviesList
            } else {
                Text("No results found")
            }
        }
        .navigationTitle("Search results for \(searchText)")
        .task {
            if let movies = self.movies {
                viewModel.movies = movies
            } else {
                if searchText == "" { return }
                await viewModel.fetchMovies(from: searchText)
            }
        }
    }
    
    var moviesList: some View {
        List(viewModel.movies, id: \.title) { movie in
            MovieCell(movie: movie)
            .onTapGesture {
                self.selectedMovie = movie
            }
        }
        .sheet(item: $selectedMovie) { movie in
            MovieDetailsView(viewModel: MovieDetailsViewModel(movie: movie))
        }
    }
    
    var loadingView: some View {
        VStack {
            ProgressView()
            Text("Loading...")
                .font(.caption)
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
    }
}

struct MovieCell: View {
    @EnvironmentObject var favoriteMoviesModel: FavoriteMoviesModel
    var movie: Movie
    
    var body: some View {
        let title = movie.title ?? "Unknown Title"
        let url = URL(string: movie.poster ?? "")
        
        HStack(spacing: 12.0) {
            AsyncImage(url: url) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(width: 75.0, height: 75.0)
                case .success(let image):
                    image.resizable()
                        .frame(width: 75.0, height: 75.0)
                        .scaledToFill()
                        .clipped()
                case .failure(let error):
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 75)
                        .foregroundColor(.gray)
                @unknown default:
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 75)
                        .foregroundColor(.gray)
                }
            }
            Text(title)
                .bold()
                .font(.headline)
            Spacer()
            Button {
                favoriteMoviesModel.toggleFavoriteMovie(movie)
            } label: {
                Image(systemName: favoriteMoviesModel.isFavoriteMovie(movie) ? "star.fill" : "star")
                    .foregroundColor(.yellow)
            }
            .buttonStyle(.borderless)
        }
    }
}

#Preview {
    MoviesListView(searchText: "Batman")
        .environmentObject(FavoriteMoviesModel())
}
