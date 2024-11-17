//
//  MovieRepository.swift
//  movapp
//
//  Created by Ajie DR on 07/11/24.
//

import Foundation

protocol MovieRepositoryProtocol {
    
    func getTopRatedMovies(page: Int) async -> Result<MovieListModel, URLError>
    
    func getMovieDetail(movieId: Int) async -> Result<MovieDetailModel, URLError>
    
}

final class MovieRepository: NSObject {
    fileprivate let remote: RemoteDataSource
    
    private init(remote: RemoteDataSource) {
        self.remote = remote
    }
    
    static func getInstance(remote: RemoteDataSource) -> MovieRepository {
        return MovieRepository(remote: remote)
    }
}


extension MovieRepository: MovieRepositoryProtocol {
    func getTopRatedMovies(page: Int) async -> Result<MovieListModel, URLError> {
        do {
            let movieList = try await remote.getTopRatedMovies(page: page)
            return .success(MovieMapper.mapMovieListResponseToModel(response: movieList))
        } catch let error as URLError {
            return .failure(error)
        } catch {
            return .failure(.unknownError(error.localizedDescription))
        }
    }
    
    func getMovieDetail(movieId: Int) async -> Result<MovieDetailModel, URLError> {
        do {
            let movieDetail = try await remote.getMovieDetail(movieId: movieId)
            return .success(MovieMapper.mapMovieDetailResponseToModel(response: movieDetail))
        } catch let error as URLError {
            return .failure(error)
        } catch {
            return .failure(.unknownError(error.localizedDescription))
        }
    }
}

final class MockMovieRepository: MovieRepositoryProtocol {
    // MARK: - Mock Data
    private let mockMovieList = MovieListModel(
        page: 1,
        results: [
            MovieListItemModel(
                adult: false,
                backdropPath: "/path1.jpg",
                id: 1,
                originalLanguage: "en",
                originalTitle: "The Mock Movie",
                overview: "A fantastic mock movie about software testing",
                popularity: 8.9,
                posterPath: "/9cqNxx0GxF0bflZmeSMuL5tnGzr.jpg",
                releaseDate: "2024-01-01",
                title: "The Mock Movie",
                video: false,
                voteAverage: 8.5,
                voteCount: 1234
            ),
            MovieListItemModel(
                adult: false,
                backdropPath: "/path2.jpg",
                id: 2,
                originalLanguage: "es",
                originalTitle: "La Película Simulada",
                overview: "Una película increíble sobre pruebas de software",
                popularity: 7.8,
                posterPath: "/9cqNxx0GxF0bflZmeSMuL5tnGzr.jpg",
                releaseDate: "2024-02-01",
                title: "The Simulated Movie",
                video: false,
                voteAverage: 7.9,
                voteCount: 987
            ),
            MovieListItemModel(
                adult: true,
                backdropPath: "/path3.jpg",
                id: 3,
                originalLanguage: "fr",
                originalTitle: "Le Film Mock",
                overview: "Un film magnifique sur les tests",
                popularity: 6.7,
                posterPath: "/poster3.jpg",
                releaseDate: "2024-03-01",
                title: "The Mock Film",
                video: true,
                voteAverage: 6.8,
                voteCount: 456
            )
        ],
        totalPages: 10,
        totalResults: 100
    )
    
    private let mockMovieDetail = MovieDetailModel(
        originalTitle: "The Mock Movie",
        overview: "A fantastic mock movie about software testing",
        language: "en",
        originCountry: "US",
        adult: false,
        backdropPath: "/9cqNxx0GxF0bflZmeSMuL5tnGzr.jpg",
        budget: 1000000,
        genres: ["Action", "Comedy", "Drama"],
        homepage: "https://mockmovie.com",
        id: 1,
        imdbID: "tt1234567",
        popularity: 8.9,
        posterPath: "/poster.jpg",
        releaseDate: "2024-01-01",
        revenue: 5000000,
        runtime: 120,
        status: "Released",
        tagline: "The best mock movie ever",
        title: "The Mock Movie",
        video: false,
        voteAverage: 8.5,
        voteCount: 1234
    )
    
    // MARK: - Error Simulation
    var shouldReturnError = false
    
    // MARK: - Protocol Implementation
    func getTopRatedMovies(page: Int) async -> Result<MovieListModel, URLError> {
        if shouldReturnError {
            return .failure(URLError.unknownError("Unknown error"))
        }
        return .success(mockMovieList)
    }
    
    func getMovieDetail(movieId: Int) async -> Result<MovieDetailModel, URLError> {
        if shouldReturnError {
            return .failure(URLError.unknownError("Unknown error"))
        }
        return .success(mockMovieDetail)
    }
}
