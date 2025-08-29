//
//  MovieDetailsView.swift
//  SwiftUIMovieApp
//
//  Created by Elijah Tristan Huey  CHAN on 8/14/25.
//

import SwiftUI

struct MovieDetailsView: View {
    @EnvironmentObject var favoriteMoviesModel: FavoriteMoviesModel
    @StateObject var viewModel: MovieDetailsViewModel
    @State var isOverviewExpanded: Bool = false
    
    var body: some View {
        ScrollView {
            if viewModel.isLoading {
                loadingView
            } else {
                VStack {
                    ZStack(alignment: .leading) {
                        moviePosterView
                    }
                    .shadow(radius: 8)
                    .frame(maxHeight: UIScreen.main.bounds.height * 0.4)
                    
                    HStack {
                        //title and favorite button
                        let title = viewModel.movie.title ?? ""
                        let date = viewModel.movie.year ?? ""
                        let titleAndDate = "\(title) (\(date))"
                        Text(titleAndDate)
                            .font(.title)
                            .bold()
                            .foregroundStyle(.secondary)
                        Spacer()
                        
                        Button {
                            favoriteMoviesModel.toggleFavoriteMovie(viewModel.movie)
                        } label: {
                            Image(systemName: favoriteMoviesModel.isFavoriteMovie(viewModel.movie) ? "star.fill" : "star")
                        }
                    }
                    .padding(12.0)
                    
                    movieDetailsView
                    
                    HStack {
                        Button {
                            
                        } label : {
                            Image(systemName: "play.circle")
                            Text("Watch Trailer")
                                .font(.callout)
                        }
                        Spacer()
                    }
                    .padding(12.0)
                    
                    movieOverview
                    
                    movieCast
                    Spacer()
                }
            }
        }
        .background(Color(.secondarySystemBackground))
        .onAppear() {
            Task {
                await viewModel.fetchDetailedMovie()
            }
        }
        
    }
    
    var loadingView: some View {
        VStack {
            Spacer()
            
            ProgressView()
                .frame(width: 80, height: 80)
            Text("Loading...")
                .font(.caption)
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
    }
    
    var moviePosterView: some View {
        var url = URL(string: viewModel.movie.poster ?? "")
        
        return AsyncImage(url: url!) { phase in
            switch phase {
            case .empty:
                ProgressView()
                    .frame(width: 200, height: 200)
            case .success(let image):
                image
                    .resizable()
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    .clipped()
                
            case .failure(let error):
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 75)
                    .foregroundColor(.gray)
            }
        }
    }
    
    var movieDetailsView: some View {
        VStack {
            HStack {
                Text("Directed By: \(viewModel.movie.director ?? "")")
                    .font(.subheadline)
                Spacer()
            }
            HStack {
                Text(viewModel.movie.genre ?? "")
                    .font(.subheadline)
                Text(viewModel.movie.runtime ?? "")
                    .font(.subheadline)
                Spacer()
            }
            
            if let rank = viewModel.movie.imdbRating {
                HStack {
                    Text("IMDB \(rank)/10")
                        .font(.footnote)
                    Image(systemName: "star.fill")
                        .foregroundStyle(Color.yellow)
                    Spacer()
                }
            }
        }
        .padding(.leading, 12.0)
        .padding(.trailing, 12.0)
    }
    
    var movieOverview: some View {
        VStack {
            HStack {
                Text("Overview")
                    .bold()
                Spacer()
            }
            .padding(.bottom, 12.0)
            
            HStack {
                var plot = viewModel.movie.plot ?? ""
                let shortenedPlot = plot.prefix(50) + "... read more"
                Text(isOverviewExpanded ? plot : String(shortenedPlot))
                .onTapGesture {
                    self.isOverviewExpanded.toggle()
                }
                Spacer()
            }
        }
        .padding(12.0)
    }
    
    var movieCast: some View {
        HStack {
            VStack {
                HStack {
                    Text("Cast:")
                        .bold()
                    Spacer()
                }
                HStack {
                    Text(viewModel.movie.actors ?? "")
                        .font(.body)
                        .bold()
                    Spacer()
                }
            }
            Spacer()
        }
        .padding(12.0)
    }
}

#Preview {
    MovieDetailsView(viewModel: MovieDetailsViewModel(movie: .preview))
        .environmentObject(FavoriteMoviesModel())
}
