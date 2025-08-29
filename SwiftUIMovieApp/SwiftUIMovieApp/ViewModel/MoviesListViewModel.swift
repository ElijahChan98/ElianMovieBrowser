//
//  MoviesListViewModel.swift
//  SwiftUIMovieApp
//
//  Created by Elijah Tristan Huey  CHAN on 8/13/25.
//

import Combine
import Foundation

@MainActor
class MoviesListViewModel: ObservableObject {
    private var cancellables: Set<AnyCancellable> = []
    @Published var isLoading: Bool = false
    @Published var movies: [Movie] = []
    @Published var currentFilterType: String? = nil
    var filterTypes = ["Name", "Year", "Rating"]
    
    func setupPublishers() {
        $currentFilterType
            .receive(on: RunLoop.main)
            .sink { [weak self] filterType in
                if let filterType = filterType {
                    switch filterType {
                    case "Name":
                        self?.movies.sort { $0.title ?? "" > $1.title ?? "" }
                        break
                    case "Year":
                        self?.movies.sort { Int($0.year ?? "0") ?? 0 > Int($1.year ?? "0") ?? 0 }
                        break
                    case "Rating":
                        self?.movies.sort { Double($0.imdbRating ?? "0.0") ?? 0 > Double($1.imdbRating ?? "0.0") ?? 0 }
                        break
                    default:
                        break
                    }
                }
            }
            .store(in: &cancellables)
    }
    
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
