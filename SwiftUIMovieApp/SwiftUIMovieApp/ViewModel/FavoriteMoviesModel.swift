//
//  FavoriteMoviesModel.swift
//  SwiftUIMovieApp
//
//  Created by Elijah Tristan Huey  CHAN on 8/14/25.
//

import Combine

class FavoriteMoviesModel: ObservableObject {
    @Published var favoriteMovies: [Movie] = []
    
    func addMovie(_ movie: Movie) {
        if !favoriteMovies.contains(where: { $0.title == movie.title }) {
            favoriteMovies.append(movie)
        }
    }
    
    func removeMovie(_ movie: Movie) {
        favoriteMovies.removeAll(where: { $0.title == movie.title })
    }
    
    func toggleFavoriteMovie(_ movie: Movie) {
        if favoriteMovies.contains(where: { $0.title == movie.title }) {
            removeMovie(movie)
        } else {
            addMovie(movie)
        }
    }
    
    func isFavoriteMovie(_ movie: Movie) -> Bool {
        favoriteMovies.contains(where: { $0.title == movie.title })
    }
}
