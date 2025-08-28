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
    weak var view: HomeViewControllerInterface?
    
    let networkServive = NetworkService.shared
    var movieItems: [MovieResult] = []
    var currentPage: Int = 1
    var isLoading = false
    var onError: ((String, String) -> Void)?
}

extension HomeViewModel: HomeViewModelInterface {
    func viewDidLoad() {
        Task{
            await getMovies()
        }
    }
    
    func viewWillAppear() {
        
    }
    
    @MainActor
    func getMovies() async {
        guard !isLoading else { return }
        isLoading = true
        view?.showProgress()
        
        defer {
            isLoading = false
            view?.removeProgress()
        }
        
        do {
            let movies = try await networkServive.fetchData(page: currentPage)
            let newItems = movies?.results ?? []
            guard !newItems.isEmpty else { return }
            
            let oldCount = movieItems.count
            movieItems.append(contentsOf: newItems)
            let indexPaths = (oldCount..<(movieItems.count)).map { IndexPath(item: $0, section: 0) }
            view?.insertItems(at: indexPaths)
            currentPage += 1
        } catch {
            await MainActor.run {
                self.onError?("Error!", "Can't retrieve data. Please try again later.")
            }
        }
        isLoading = false
    }
}

