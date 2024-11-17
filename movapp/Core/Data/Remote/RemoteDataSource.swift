//
//  RemoteDataSource.swift
//  movapp
//
//  Created by Ajie DR on 06/11/24.
//

import Foundation

protocol RemoteDataSourceProtocol: AnyObject {
    func getTopRatedMovies(page: Int) async throws -> MovieListResponse
    func getMovieDetail(movieId: Int) async throws -> MovieDetailResponse
}

final class RemoteDataSource: NSObject {
    private override init () {}
    static let sharedInstance: RemoteDataSource = RemoteDataSource()
}
                        
extension RemoteDataSource: RemoteDataSourceProtocol {
    func getTopRatedMovies(page: Int) async throws -> MovieListResponse {
        
        guard let url = URL(string: Endpoints.Gets.topRated(page).url) else {
            throw URLError.addressUnreachable(Endpoints.Gets.topRated(page).url)
        }
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        let queryItems: [URLQueryItem] = [
          URLQueryItem(name: "language", value: "en-US"),
          URLQueryItem(name: "page", value: "1"),
        ]
        
        components.queryItems = components.queryItems.map { $0 + queryItems } ?? queryItems

        let request = getRequest(urlComponents: components, httpMethod: HTTPMethod.GET)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode)
        else { throw URLError.invalidResponse }
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(MovieListResponse.self, from: data)
        } catch {
            throw URLError.invalidResponse
        }
    }
    
    func getMovieDetail(movieId: Int) async throws -> MovieDetailResponse {
        
        guard let url = URL(string: Endpoints.Gets.detail(movieId).url) else {
            throw URLError.addressUnreachable(Endpoints.Gets.detail(movieId).url)
        }
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        let queryItems: [URLQueryItem] = [
          URLQueryItem(name: "language", value: "en-US"),
          URLQueryItem(name: "page", value: "1"),
        ]
        
        components.queryItems = components.queryItems.map { $0 + queryItems } ?? queryItems

        let request = getRequest(urlComponents: components, httpMethod: HTTPMethod.GET)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode)
        else { throw URLError.invalidResponse }
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(MovieDetailResponse.self, from: data)
        } catch {
            throw URLError.invalidResponse
        }
    }
    
    private func getRequest(urlComponents: URLComponents, httpMethod: HTTPMethod) -> URLRequest {
        var request = URLRequest(url: urlComponents.url!)
        
        request.httpMethod = httpMethod.method
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = [
          "accept": "application/json",
          "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJhYWRiMWIxNGY3ODRkOTRjODdiNDQ3ZDEzZGEwNzIzYSIsIm5iZiI6MTczMTIyNzYyMi42NDIyMywic3ViIjoiNjA4ODBlYzc1NWM5MjYwMDQxNzYxM2NlIiwic2NvcGVzIjpbImFwaV9yZWFkIl0sInZlcnNpb24iOjF9.uvwE0SsiPSHtn0NWfDIFFT7DQG4pkjDZoL1XApAkGYk"
        ]
        
        return request
    }
}

enum HTTPMethod {
    case GET
    case POST
    case PUT
    case DELETE
    
    var method: String {
        switch self {
        case .GET: return "GET"
        case .POST: return "POST"
        case .PUT: return "PUT"
        case .DELETE: return "DELETE"
        }
    }
}
