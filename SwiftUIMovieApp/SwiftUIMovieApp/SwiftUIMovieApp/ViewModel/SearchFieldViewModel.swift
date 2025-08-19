//
//  SearchFieldViewModel.swift
//  SwiftUIMovieApp
//
//  Created by Elijah Tristan Huey  CHAN on 8/18/25.
//

import Combine
import Foundation

@MainActor
class SearchFieldViewModel: ObservableObject {
    private var cancellables: Set<AnyCancellable> = []
    @Published var searchText: String = ""
    @Published var movies: [Movie] = []
    
    func bindSearchResults() {
        $searchText
            .debounce(for: 0.4, scheduler: RunLoop.main)
            .receive(on: RunLoop.main)
            .flatMap { text in
                return NetworkManager.shared.fetchPublisher(endpoint: "", parameters: ["s": text], type: MoviesResult.self)
            }
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("Publisher finished")
                case .failure(let error):
                    print("Publisher failed with error:", error)
                }
            }, receiveValue: { result in
                self.movies = result.movies ?? []
            })
            .store(in: &cancellables)
    }
}
