//
//  MovieDetailViewModel.swift
//  Movietopia
//
//  Created by Bora Özel on 28/8/25.
//

import Foundation

protocol MovieDetailViewModelInterface {
    var networkService: NetworkServiceProtocol { get }
}

final class MovieDetailViewModel {
    weak var view: MovieDetailViewControllerInterface?
    private(set) var networkService: NetworkServiceProtocol
    
    init(view: MovieDetailViewControllerInterface,
         networkService: NetworkServiceProtocol = NetworkService.shared) {
        self.view = view
        self.networkService = networkService
    }
}

extension MovieDetailViewModel: MovieDetailViewModelInterface {
    
}
