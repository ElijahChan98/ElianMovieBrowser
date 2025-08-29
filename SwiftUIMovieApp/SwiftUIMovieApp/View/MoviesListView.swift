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
    @State var showFilterList: Bool = false
    
    var body: some View {
        ZStack {
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
            .toolbar {
                Button("Filter") {
                    showFilterList.toggle()
                }
                .anchorPreference(key: ButtonAnchorKey.self, value: .bounds) { $0 }
            }
        }
        .overlayPreferenceValue(ButtonAnchorKey.self) { anchor in
            GeometryReader { proxy in
                if showFilterList, let anchor {
                    let buttonFrame = proxy[anchor]
                    
                    filterListView
                        .frame(alignment: .topLeading)
                        .offset(
                            x: buttonFrame.maxX - 150,
                            y: buttonFrame.maxY - 30 // push it below the button
                        )
                }
            }
        }
        .task {
            viewModel.setupPublishers()
            if let movies = self.movies {
                viewModel.movies = movies
            } else {
                if searchText == "" { return }
                await viewModel.fetchMovies(from: searchText)
            }
        }
    }
    
    var filterListView: some View {
        VStack {
            ForEach(viewModel.filterTypes, id: \.self) { filterType in
                VStack {
                    FilterCell(filterText: filterType, isSelected: viewModel.currentFilterType == filterType)
                        .onTapGesture {
                            viewModel.currentFilterType = filterType
                        }
                    Divider()
                        .padding(.leading, 8.0)
                }
            }
        }
        .background(.thinMaterial)
        .shadow(radius: 8.0)
        .cornerRadius(8.0)
        .frame(width: 150)
        .padding(.top, 40)
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

struct ButtonAnchorKey: PreferenceKey {
    static var defaultValue: Anchor<CGRect>? = nil
    
    static func reduce(value: inout Anchor<CGRect>?, nextValue: () -> Anchor<CGRect>?) {
        value = nextValue() ?? value
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

struct FilterCell: View {
    var filterText: String
    var isSelected: Bool
    
    var body: some View {
        HStack {
            Text(filterText)
            Spacer()
            Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                .foregroundColor(isSelected ? .yellow : .gray)
                .scaleEffect(isSelected ? 1.2 : 1.0)
                .animation(.spring(), value: isSelected)
        }
        .padding(8.0)
    }
}

#Preview {
    MoviesListView(searchText: "Batman")
        .environmentObject(FavoriteMoviesModel())
}
