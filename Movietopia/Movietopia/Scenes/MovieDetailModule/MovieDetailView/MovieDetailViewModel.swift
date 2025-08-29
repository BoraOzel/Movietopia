//
//  MovieDetailViewModel.swift
//  Movietopia
//
//  Created by Bora Özel on 28/8/25.
//

import Foundation

protocol MovieDetailViewModelInterface {
    func viewDidLoad()
}

class MovieDetailViewModel {
    weak var view: MovieDetailViewControllerInterface?
    
}

extension MovieDetailViewModel: MovieDetailViewModelInterface {
    func viewDidLoad() {
        
    }
}
