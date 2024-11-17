//
//  API.swift
//  movapp
//
//  Created by Ajie DR on 06/11/24.
//

import Foundation

struct API {
    static let baseUrl = "https://api.themoviedb.org"
}

protocol Endpoint {
  var url: String { get }
}

enum Endpoints {
    
    enum Gets: Endpoint {
        case topRated(Int)
        case detail(Int)
        
        public var url : String {
            switch self {
            case .topRated(let page):
                return "\(API.baseUrl)/3/movie/top_rated?page=\(page)"
            case .detail(let id):
                return "\(API.baseUrl)/3/movie/\(id)"
            }
        }
    }
}
