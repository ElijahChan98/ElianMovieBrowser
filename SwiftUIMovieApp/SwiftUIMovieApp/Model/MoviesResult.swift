//
//  MoviesResult.swift
//  SwiftUIMovieApp
//
//  Created by Elijah Tristan Huey  CHAN on 8/13/25.
//

struct MoviesResult: Codable {
    var movies: [Movie]?
    
    enum CodingKeys: String, CodingKey {
        case movies = "Search"
    }
}
