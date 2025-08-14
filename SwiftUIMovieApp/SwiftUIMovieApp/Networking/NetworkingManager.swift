//
//  NetworkingLayer.swift
//  SwiftUIMovieApp
//
//  Created by Elijah Tristan Huey  CHAN on 8/13/25.
//

import Foundation
import Combine

protocol NetworkService {
    func fetchAsync<T: Codable>(endpoint: String, parameters: [String: String]?, type: T.Type) async throws -> T
    func fetchPublisher<T: Codable>(endpoint: String, parameters: [String: String]?, type: T.Type) -> AnyPublisher<T, Error>
}

class NetworkManager: NetworkService {
    fileprivate static let apiKey = "3f94652c" //Note: very bad practice to save API keys like this. Learn to obfuscate API keys in the future
    private let baseURL = URL(string: "https://www.omdbapi.com/")!
    private let session: URLSession
    
    public static let shared = NetworkManager()
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func fetchAsync<T: Codable>(endpoint: String, parameters: [String: String]? = nil, type: T.Type) async throws -> T {
        var urlComponents = URLComponents(url: baseURL.appendingPathComponent(endpoint), resolvingAgainstBaseURL: false)!
        
        var queryItems = [URLQueryItem(name: "apikey", value: NetworkManager.apiKey)]
        if let parameters = parameters {
            queryItems.append(contentsOf: parameters.map { URLQueryItem(name: $0.key, value: $0.value) })
        }
        
        urlComponents.queryItems = queryItems
        
        guard let url = urlComponents.url else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await session.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              200..<300 ~= httpResponse.statusCode else {
            throw URLError(.badServerResponse)
        }
        
        let json = try JSONDecoder().decode(T.self, from: data)
        return json
    }
    
    func fetchPublisher<T: Codable>(endpoint: String, parameters: [String: String]? = nil, type: T.Type) -> AnyPublisher<T, Error> {
        var urlComponents = URLComponents(url: baseURL.appendingPathComponent(endpoint), resolvingAgainstBaseURL: false)!
        
        var queryItems = [URLQueryItem(name: "apikey", value: NetworkManager.apiKey)]
        if let parameters = parameters {
            queryItems.append(contentsOf: parameters.map { URLQueryItem(name: $0.key, value: $0.value) })
        }
        
        urlComponents.queryItems = queryItems
        
        guard let url = urlComponents.url else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        return session.dataTaskPublisher(for: url)
            .tryMap { data, response -> Data in
                guard let httpResponse = response as? HTTPURLResponse,
                      200..<300 ~= httpResponse.statusCode else {
                    throw URLError(.badServerResponse)
                }
                return data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

}
