//
//  Movie.swift
//  SwiftUIMovieApp
//
//  Created by Elijah Tristan Huey  CHAN on 8/13/25.
//

struct Movie: Codable, Hashable, Identifiable {
    var id: String?
    
    let imdbID: String?
    let title: String?
    let year: String?
    let rated: String?
    let runtime: String?
    let genre: String?
    let director: String?
    let plot: String?
    let language: String?
    let poster: String?
    let metascore: String?
    let imdbRating: String?
    let actors: String?
    
    enum CodingKeys: String, CodingKey {
        case id, imdbID = "imdbID"
        
        case title = "Title"
        case year = "Year"
        case rated = "Rated"
        case runtime = "Runtime"
        case genre = "Genre"
        case director = "Director"
        case plot = "Plot"
        case language = "Language"
        case poster = "Poster"
        case metascore = "Metascore"
        case imdbRating = "imdbRating"
        case actors = "Actors"
    }
}

extension Movie {
    static let preview = Movie(
        id: "1",
        imdbID: "tt1234567",
        title: "Sample Movie",
        year: "2025",
        rated: "PG",
        runtime: "120 min",
        genre: "Drama",
        director: "Jane Doe",
        plot: "As Harvard student Mark Zuckerberg creates the social networking site that would become known as Facebook, he is sued by the twins who claimed he stole their idea and by the co-founder who was later squeezed out of the business.",
        language: "English",
        poster: "sshttps://m.media-amazon.com/images/M/MV5BODIyMDdhNTgtNDlmOC00MjUxLWE2NDItODA5MTdkNzY3ZTdhXkEyXkFqcGc@._V1_SX300.jpg",
        metascore: "85",
        imdbRating: "8.5",
        actors: "Actor1, actor 2, actor 3",
    )
}
