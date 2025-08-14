//
//  MovieDetailsViewModel.swift
//  SwiftUIMovieApp
//
//  Created by Elijah Tristan Huey  CHAN on 8/14/25.
//

import Combine

@MainActor
class MovieDetailsViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var movie: Movie
    
    init(movie: Movie) {
        self.movie = movie
    }
    
    func fetchDetailedMovie() async {
        isLoading = true
        do {
            let id = movie.imdbID ?? ""
            let movie = try await NetworkManager.shared.fetchAsync(endpoint: "", parameters: ["i": id, "plot": "full"], type: Movie.self)
            
            self.movie = movie
            isLoading = false
        } catch {
            isLoading = false
        }
    }
}
