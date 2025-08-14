//
//  HomeViewModel.swift
//  SwiftUIMovieApp
//
//  Created by Elijah Tristan Huey  CHAN on 8/13/25.
//
import Combine

@MainActor
class HomeViewModel: ObservableObject {
    @Published var searchText: String = ""
}
