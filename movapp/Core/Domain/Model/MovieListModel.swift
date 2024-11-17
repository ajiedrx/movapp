//
//  MovieListModel.swift
//  movapp
//
//  Created by Ajie DR on 06/11/24.
//

struct MovieListModel {
    let page: Int?
    let results: [MovieListItemModel]?
    let totalPages, totalResults: Int?
}

struct MovieListItemModel: Identifiable {
    let adult: Bool?
    let backdropPath: String?
    let id: Int?
    let originalLanguage, originalTitle, overview: String?
    let popularity: Double?
    let posterPath, releaseDate, title: String?
    let video: Bool?
    let voteAverage: Double?
    let voteCount: Int?
}
