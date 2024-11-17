//
//  MovieDetailViewModel.swift
//  movapp
//
//  Created by Ajie DR on 10/11/24.
//

import Foundation

class MovieDetailViewModel: ObservableObject {
    //Dependencies
    private var movieUseCase: MovieUseCase
    
    //Tasks
    private var getMovieDetailTask: Task<Void, Never>?
    
    //Observables
    @Published var detailViewState: ViewState<MovieDetailModel, URLError> = .loading
        
    init(movieUseCase: MovieUseCase) {
        self.movieUseCase = movieUseCase
    }
    
    func getMovieDetail(movieId: Int) {
        getMovieDetailTask?.cancel()
        
        detailViewState = .loading
        
        getMovieDetailTask = Task {
            guard !Task.isCancelled
            else {
                await MainActor.run { detailViewState = .idle }
                return
            }
            
            let result = await movieUseCase.getMovieDetails(movieId: movieId)
            
            await MainActor.run {
                switch result {
                case .success(let movieDetail):
                    detailViewState = .success(movieDetail)
                case .failure(let error):
                    detailViewState = .failure(error)
                }
            }
        }
    }
    
    func onViewDisappear() {
        getMovieDetailTask?.cancel()
        getMovieDetailTask = nil
        detailViewState = .idle
    }
}
