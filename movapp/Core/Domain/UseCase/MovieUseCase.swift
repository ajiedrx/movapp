//
//  MovieUseCase.swift
//  movapp
//
//  Created by Ajie DR on 08/11/24.
//

protocol MovieUseCase {
    
    func getTopRatedMovies(page: Int) async -> Result<MovieListModel, URLError>
    
    func getMovieDetails(movieId: Int) async -> Result<MovieDetailModel, URLError>
    
}

class MovieUseCaseImpl: MovieUseCase {
    private let movieRepository: MovieRepositoryProtocol
    
    required init(movieRepository: MovieRepositoryProtocol) {
        self.movieRepository = movieRepository
    }
    
    func getTopRatedMovies(page: Int) async -> Result<MovieListModel, URLError> {
        return await movieRepository.getTopRatedMovies(page: page)
    }
    
    func getMovieDetails(movieId: Int) async -> Result<MovieDetailModel, URLError> {
        return await movieRepository.getMovieDetail(movieId: movieId)
    }
}
