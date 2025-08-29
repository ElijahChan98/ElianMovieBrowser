//
//  FavoriteMoviesModel.swift
//  SwiftUIMovieApp
//
//  Created by Elijah Tristan Huey  CHAN on 8/14/25.
//

import Combine
import SwiftUI

class FavoriteMoviesModel: ObservableObject {
    @AppStorage("storedFavoriteMovies") private var storedFavoriteMovies: Data = Data()
    
    @Published var favoriteMovies: [Movie] = [] {
        didSet {
            do {
                storedFavoriteMovies = try JSONEncoder().encode(favoriteMovies)
            } catch {
                print("error encoding favorite movies")
            }
        }
    }
    
    init() {
        getAllStoredFavoriteMovies()
    }
    
    private func getAllStoredFavoriteMovies() {
        do {
            favoriteMovies = try JSONDecoder().decode([Movie].self, from: storedFavoriteMovies)
        }
        catch {
            print("error decoding favorite movies")
        }
    }
    
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
