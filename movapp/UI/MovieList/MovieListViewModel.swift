//
//  MovieListViewModel.swift
//  movapp
//
//  Created by Ajie DR on 10/11/24.
//

import Foundation

class MovieListViewModel: ObservableObject {
    //Dependencies
    private var movieUseCase: MovieUseCase
    
    //Tasks
    private var getTopRatedMoviesTask: Task<Void, Never>?
    
    //Observables
    @Published var listViewState: ViewState<[MovieListItemModel], URLError> = .loading
        
    init(movieUseCase: MovieUseCase) {
        self.movieUseCase = movieUseCase
    }
    
    func getTopRatedMovies() {
        getTopRatedMoviesTask?.cancel()
        
        listViewState = .loading
        
        getTopRatedMoviesTask = Task {
            guard !Task.isCancelled
            else {
                await MainActor.run { listViewState = .idle }
                return
            }
            
            let result = await movieUseCase.getTopRatedMovies(page: 1) //TODO paging
            
            await MainActor.run {
                switch result {
                case .success(let movieList):
                    listViewState = .success(movieList.results ?? [])
                case .failure(let error):
                    listViewState = .failure(error)
                }
            }
        }
    }
    
    func onViewDisappear() {
        getTopRatedMoviesTask?.cancel()
        getTopRatedMoviesTask = nil
        listViewState = .idle
    }
}
