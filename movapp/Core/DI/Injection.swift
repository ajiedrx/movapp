//
//  Injection.swift
//  movapp
//
//  Created by Ajie DR on 08/11/24.
//

import Foundation

final class Injection: NSObject {
    
    private func provideRepository() -> MovieRepositoryProtocol {
        
        let remote = RemoteDataSource.sharedInstance
        
        return MovieRepository.getInstance(remote: remote)
    }
    
    func provideMovieUseCase() -> MovieUseCase {
        let repository = provideRepository()
        
        return MovieUseCaseImpl(movieRepository: repository)
    }
}
