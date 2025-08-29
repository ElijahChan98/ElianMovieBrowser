//
//  SearchFieldWithDropdown.swift
//  SwiftUIMovieApp
//
//  Created by Elijah Tristan Huey  CHAN on 8/18/25.
//

import SwiftUI
import Combine

struct SearchFieldWithDropdown: View {
    @StateObject var viewModel: SearchFieldViewModel = SearchFieldViewModel()
    @Binding var searchText: String
    @Binding var isShowingDropdown: Bool
    
    var onResultSelect: (Movie) -> Void
    
    var body: some View {
        ZStack {
            searchBar
                .overlay(alignment: .top) {
                    if isShowingDropdown {
                        listDropdown
                            .padding(4.0)
                            .offset(y: 30)
                    }
                }.opacity(1)
        }
        
        .onChange(of: viewModel.movies.count) { oldValue, newValue in
            isShowingDropdown = newValue > 0
        }
    }
    
    var searchBar: some View {
        TextField("Search Movie", text: $searchText)
            .font(.headline)
            .textFieldStyle(.roundedBorder)
            .multilineTextAlignment(.center)
            .frame(maxWidth: 300.0)
            .onChange(of: searchText, { oldValue, newValue in
                self.viewModel.searchText = newValue
                self.viewModel.bindSearchResults()
            })
    }
    
    var listDropdown: some View {
        ScrollView {
            LazyVStack {
                ForEach(viewModel.movies, id: \.self) { movie in
                    Text(movie.title ?? "")
                        .frame(height: 30.0)
                        .onTapGesture {
                            self.onResultSelect(movie)
                        }
                }
            }
        }
        .frame(width: 300, height: min(CGFloat(viewModel.movies.count) * 30, 200))
        .background(.thickMaterial)
        .shadow(radius: 15)
        .cornerRadius(15)
    }
}

#Preview {
    SearchFieldWithDropdown(searchText: .constant("Star Wars"), isShowingDropdown: .constant(false)) { _ in
        
    }
}
