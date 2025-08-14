//
//  MoviesListViewModel.swift
//  SwiftUIMovieApp
//
//  Created by Elijah Tristan Huey  CHAN on 8/13/25.
//

import Combine

@MainActor
class MoviesListViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var movies: [Movie] = []
    
    func fetchMovies(from searchText: String) async {
        isLoading = true
        do {
            let result = try await NetworkManager.shared.fetchAsync(endpoint: "", parameters: ["s": searchText], type: MoviesResult.self)
            isLoading = false
            self.movies = result.movies ?? []
        } catch {
            print(error.localizedDescription)
            isLoading = false
            self.movies = []
        }
    }
}
