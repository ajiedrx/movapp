//
//  Common.swift
//  movapp
//
//  Created by Ajie DR on 10/11/24.
//

enum ViewState<Success, Failure> where Failure : Error {
    case idle
    case loading
    case success(Success)
    case failure(Failure)
}

enum ImageURL {
    case icon(String)
    case backdrop(String)
    
    var imageURL: String {
        switch self {
        case .icon(let url): return "https://image.tmdb.org/t/p/w92" + url
        case .backdrop(let url): return "https://image.tmdb.org/t/p/w500" + url
        }
    }
}
