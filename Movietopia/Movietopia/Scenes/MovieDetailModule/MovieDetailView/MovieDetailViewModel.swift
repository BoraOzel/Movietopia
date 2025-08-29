//
//  MovieDetailViewModel.swift
//  Movietopia
//
//  Created by Bora Özel on 28/8/25.
//

import Foundation

protocol MovieDetailViewModelInterface {

}

class MovieDetailViewModel {
    weak var view: MovieDetailViewControllerInterface?
    
}

extension MovieDetailViewModel: MovieDetailViewModelInterface {

}
