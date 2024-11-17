//
//  MovieListView.swift
//  movapp
//
//  Created by Ajie DR on 10/11/24.
//

import Foundation
import SwiftUI

struct MovieHome: View {
    
    @StateObject private var movieListViewModel: MovieListViewModel
    
    init(movieListViewModel: MovieListViewModel) {
        _movieListViewModel = StateObject(wrappedValue: movieListViewModel)
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                switch movieListViewModel.listViewState {
                case .idle: EmptyView()
                case .loading: LoadingView()
                case .success(let movieList): MovieListView(movieList: movieList)
                case .failure(let error): ErrorView(error: error, retryAction: movieListViewModel.getTopRatedMovies)
                }
            }
            .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        NavigationLink(value: StandaloneRoutes.profile) {
                            Text("Profile")
                        }
                    }
                }
            .navigationTitle("Top Rated Movies")
            .navigationDestination(for: StandaloneRoutes.self) { route in
                switch route{
                case .profile: ProfileView()
                }
            }
        }
        .onAppear {
            movieListViewModel.getTopRatedMovies()
        }
        .onDisappear {
            movieListViewModel.onViewDisappear()
        }
    }
}

struct MovieListView: View {
    let movieList: [MovieListItemModel]
    
    var body: some View {
        List {
            ForEach(movieList) { movie in
                NavigationLink(value: movie.id) {
                    MovieListItemView(
                        movieId: String(movie.id ?? 0),
                        imageURL: movie.posterPath ?? "",
                        title: movie.title ?? ""
                    )
                }
            }
        }.navigationDestination(for: Int.self) { movieId in
            MovieDetailView(
                viewModel: MovieDetailViewModel(
                    movieUseCase: Injection.init().provideMovieUseCase()
                ),
                movieId: movieId
            )
        }
    }
}

struct MovieListItemView: View {
    let movieId: String
    let imageURL: String
    let title: String
    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: ImageURL.icon(imageURL).imageURL)) { phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .clipped()
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                } else {
                    Image(systemName: "photo")
                }
            }
            .frame(width: 45, height: 68)
            
            Text(title)
                .padding(.leading, 12)
                .lineLimit(1)
        }
    }
}

struct LoadingView: View {
    var body: some View {
        ProgressView()
            .progressViewStyle(CircularProgressViewStyle())
            .scaleEffect(1.5)
    }
}

struct ErrorView: View {
    let error: URLError
    let retryAction: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Something went wrong")
                .font(.headline)
            
            Text(error.localizedDescription)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Button("Retry") {
                retryAction()
            }
        }
        .padding()
    }
}

#Preview {
    let mockViewModel = MovieListViewModel(movieUseCase: MovieUseCaseImpl(movieRepository: MockMovieRepository()))
    
    MovieHome(movieListViewModel: mockViewModel)
}

