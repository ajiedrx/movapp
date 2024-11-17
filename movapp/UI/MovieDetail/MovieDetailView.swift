//
//  MovieDetailView.swift
//  movapp
//
//  Created by Ajie DR on 10/11/24.
//

import Foundation
import SwiftUI

struct MovieDetailView: View {
    var movieId: Int
    
    @StateObject private var viewModel: MovieDetailViewModel
    
    init(viewModel: MovieDetailViewModel, movieId: Int) {
        _viewModel = StateObject(wrappedValue: viewModel)
        
        self.movieId = movieId
    }
    
    var body: some View {
        content
            .onAppear {
                viewModel.getMovieDetail(movieId: movieId)
            }
    }
    
    @ViewBuilder
    private var content: some View {
        switch viewModel.detailViewState {
        case .idle:
            Color.clear
            
        case .loading:
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
                .scaleEffect(1.5)
            
        case .success(let movie):
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    // Backdrop Image
                    AsyncImage(url: URL(string: ImageURL.backdrop(movie.backdropPath).imageURL)) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                    }
                    .frame(height: 200)
                    .clipped()
                    
                    VStack(alignment: .leading, spacing: 12) {
                        // Title and Release Date
                        VStack(alignment: .leading, spacing: 4) {
                            Text(movie.title)
                                .font(.title)
                                .fontWeight(.bold)
                            
                            Text("Released: \(movie.releaseDate)")
                                .foregroundColor(.secondary)
                        }
                        
                        // Tagline
                        if !movie.tagline.isEmpty {
                            Text(movie.tagline)
                                .italic()
                                .foregroundColor(.secondary)
                        }
                        
                        // Rating and Duration
                        HStack(spacing: 16) {
                            Label(
                                String(format: "%.1f/10", movie.voteAverage),
                                systemImage: "star.fill"
                            )
                            .foregroundColor(.yellow)
                            
                            Text("\(movie.runtime) min")
                        }
                        
                        // Genres
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(movie.genres, id: \.self) { genre in
                                    Text(genre)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 6)
                                        .background(
                                            Capsule()
                                                .fill(Color.blue.opacity(0.2))
                                        )
                                }
                            }
                        }
                        
                        // Overview
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Overview")
                                .font(.headline)
                            
                            Text(movie.overview)
                                .lineSpacing(4)
                        }
                        
                        // Additional Information
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Additional Information")
                                .font(.headline)
                            
                            Grid(alignment: .leading, horizontalSpacing: 16, verticalSpacing: 8) {
                                GridRow {
                                    Text("Original Title:")
                                        .foregroundColor(.secondary)
                                    Text(movie.originalTitle)
                                }
                                
                                GridRow {
                                    Text("Language:")
                                        .foregroundColor(.secondary)
                                    Text(movie.language.uppercased())
                                }
                                
                                GridRow {
                                    Text("Country:")
                                        .foregroundColor(.secondary)
                                    Text(movie.originCountry)
                                }
                                
                                if movie.budget > 0 {
                                    GridRow {
                                        Text("Budget:")
                                            .foregroundColor(.secondary)
                                        Text("$\(movie.budget.formatted())")
                                    }
                                }
                                
                                if movie.revenue > 0 {
                                    GridRow {
                                        Text("Revenue:")
                                            .foregroundColor(.secondary)
                                        Text("$\(movie.revenue.formatted())")
                                    }
                                }
                            }
                        }
                    }
                    .padding()
                }
            }
            
        case .failure(let error):
            VStack(spacing: 16) {
                Image(systemName: "exclamationmark.triangle")
                    .font(.largeTitle)
                    .foregroundColor(.red)
                
                Text("Error loading movie details")
                    .font(.headline)
                
                Text(error.localizedDescription)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                
                Button("Try Again") {
                    viewModel.getMovieDetail(movieId: movieId)
                }
                .buttonStyle(.bordered)
            }
            .padding()
        }
    }
}

#Preview {
    MovieDetailView(viewModel: MovieDetailViewModel(movieUseCase: MovieUseCaseImpl(movieRepository: MockMovieRepository())), movieId: 0)
}
