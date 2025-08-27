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
    func viewWillAppear()
    func getMovies() async
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
    
    func viewWillAppear() {
        
    }
    
    
    func getMovies() async {
        
        guard !isLoading else { return }
        isLoading = true
        
        DispatchQueue.main.async {
            self.view?.showProgress()
        }

        do {
            
            let movies = try await networkServive.fetchData(page: currentPage)
            let newItems = movies?.results ?? []
            guard !newItems.isEmpty else {
                isLoading = false
                DispatchQueue.main.async {
                    self.view?.removeProgress()
                }

                return
            }

            DispatchQueue.main.async {
                let oldCount = self.movieItems.count
                let added = newItems.count

                self.movieItems.append(contentsOf: newItems)

                let indexPaths = (oldCount..<(oldCount + added)).map { IndexPath(item: $0, section: 0) }

                self.view?.collectionView.performBatchUpdates({
                    self.view?.collectionView.insertItems(at: indexPaths)
})
                self.currentPage += 1
            }
        } catch {
            print(error)
        }
        
        isLoading = false
        DispatchQueue.main.async {
            self.view?.removeProgress()
        }

    }
}

