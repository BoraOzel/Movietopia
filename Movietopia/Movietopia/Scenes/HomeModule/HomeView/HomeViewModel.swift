//
//  HomeViewModel.swift
//  Movietopia
//
//  Created by Bora Özel on 26/8/25.
//

import Foundation
import SDWebImage

protocol HomeViewModelInterface: AnyObject {
    func viewDidLoad()
    func getMovies(reset: Bool) async
}

final class HomeViewModel {
    weak var view: HomeViewController?
    
    let networkServive = NetworkService.shared
    var movieItems: [MovieResult] = []
    var currentPage: Int = 1
    var isLoading = false
}

extension HomeViewModel: HomeViewModelInterface {
    func viewDidLoad() {
        Task{
            await getMovies()
        }
    }
    
    func getMovies(reset: Bool = false) async {
        
        guard !isLoading else { return }
        isLoading = true
        
        DispatchQueue.main.async {
            self.view?.collectionView.reloadData()
        }
        
        if reset {
            currentPage = 1
            movieItems.removeAll()
        }
        
        do{
            let movies = try await networkServive.fetchData(page: currentPage)
            if let moviesResponse = movies {
                DispatchQueue.main.async {
                    self.movieItems.append(contentsOf: moviesResponse.results)
                    self.view?.collectionView.reloadData()
                }
                currentPage += 1
            }
        } catch {
            print(error)
            DispatchQueue.main.async {
                self.view?.collectionView.reloadData()
            }
        }
        isLoading = false
    }
}
