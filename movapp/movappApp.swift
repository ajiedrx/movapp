//
//  movappApp.swift
//  movapp
//
//  Created by Ajie DR on 05/11/24.
//

import SwiftUI

@main
struct movappApp: App {
    var body: some Scene {
        WindowGroup {
            MovieHome(
                movieListViewModel: MovieListViewModel(movieUseCase: Injection.init().provideMovieUseCase())
            )
        }
    }
}
