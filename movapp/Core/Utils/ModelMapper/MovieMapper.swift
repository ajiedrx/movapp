//
//  MovieMapper.swift
//  movapp
//
//  Created by Ajie DR on 06/11/24.
//

final class MovieMapper {
    static func mapMovieDetailResponseToModel(response: MovieDetailResponse) -> MovieDetailModel {
        return MovieDetailModel(
            originalTitle: response.originalTitle ?? "",
            overview: response.overview ?? "",
            language: response.originalLanguage ?? "",
            originCountry: response.productionCountries?.first?.iso3166_1 ?? "",
            adult: response.adult ?? false,
            backdropPath: response.backdropPath ?? "",
            budget: response.budget ?? 0,
            genres: response.genres?.compactMap { $0.name } ?? [],
            homepage: response.homepage ?? "",
            id: response.id ?? 0,
            imdbID: response.imdbID ?? "",
            popularity: response.popularity ?? 0.0,
            posterPath: response.posterPath ?? "",
            releaseDate: response.releaseDate ?? "",
            revenue: response.revenue ?? 0,
            runtime: response.runtime ?? 0,
            status: response.status ?? "",
            tagline: response.tagline ?? "",
            title: response.title ?? "",
            video: response.video ?? false,
            voteAverage: response.voteAverage ?? 0.0,
            voteCount: response.voteCount ?? 0
        )
    }
    
    static func mapMovieListResponseToModel(response: MovieListResponse) -> MovieListModel {
        return MovieListModel(
            page: response.page ?? 0,
            results: response
                .results?
                .compactMap {
                    result in mapMovieListItemResponseToModel(response: result)
                },
            totalPages: response.totalPages ?? 0,
            totalResults: response.totalResults ?? 0
        )
    }
        
    private static func mapMovieListItemResponseToModel(response: MovieListItemResponse) -> MovieListItemModel {
        return MovieListItemModel(
            adult: response.adult ?? false,
            backdropPath: response.backdropPath ?? "",
            id: response.id ?? 0,
            originalLanguage: response.originalLanguage ?? "",
            originalTitle: response.originalTitle ?? "",
            overview: response.overview ?? "",
            popularity: response.popularity ?? 0,
            posterPath: response.posterPath ?? "",
            releaseDate: response.releaseDate ?? "",
            title: response.title ?? "",
            video: response.video ?? false,
            voteAverage: response.voteAverage ?? 0,
            voteCount: response.voteCount ?? 0
        )
    }
}
