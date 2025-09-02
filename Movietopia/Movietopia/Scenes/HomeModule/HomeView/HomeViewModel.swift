//
//  HomeViewModel.swift
//  Movietopia
//
//  Created by Bora Özel on 26/8/25.
//

import Foundation
import SDWebImage

protocol HomeViewModelInterface {
    var networkService: NetworkServiceProtocol { get }
    
    func viewDidLoad()
    func getMovies() async
    func numberOfItems() -> Int
    func getItem(at index: Int) -> MovieResult?
    func showAlertError()
    func fetchMoviesToVC()
}

final class HomeViewModel {
    private(set) var networkService: NetworkServiceProtocol
    weak var view: HomeViewControllerInterface?
    var movieItems: [MovieResult] = []
    var currentPage: Int = 1
    var isLoading = false
    
    init(view: HomeViewControllerInterface,
         networkService: NetworkServiceProtocol = NetworkService.shared) {
        self.view = view
        self.networkService = networkService
    }
}

extension HomeViewModel: HomeViewModelInterface {
    func viewDidLoad() {
        fetchMoviesToVC()
    }

    @MainActor
    func getMovies() async {
        guard !isLoading else { return }
        isLoading = true
        view?.showProgress()
        view?.showLoading(true)
        
        defer {
            isLoading = false
            view?.removeProgress()
            view?.showLoading(true)
        }
        
        do {
            let movies = try await networkService.fetchMovies(page: currentPage)
            let newItems = movies.results ?? []
            guard !newItems.isEmpty else { return }
            
            let oldCount = movieItems.count
            movieItems.append(contentsOf: newItems)
            let indexPaths = (oldCount..<(movieItems.count)).map { IndexPath(item: $0, section: 0) }
            view?.insertItems(at: indexPaths)
            currentPage += 1
        } catch {
            await MainActor.run {
                showAlertError()
            }
        }
        isLoading = false
    }
    
    func fetchMoviesToVC() {
        Task{
            view?.showProgress()
            await getMovies()
            
            view?.removeProgress()
        }
    }
    
    func numberOfItems() -> Int {
        return movieItems.count
    }
    
    func getItem(at index: Int) -> MovieResult? {
        movieItems[index]
    }
    
    func showAlertError() {
        view?.showAlert(title: "Error!",
                        message: "Can't retrieve data. Please try again later.",
                        buttonText: "Retry") { _ in
            Task {
                await self.getMovies()
            }
        }
    }
}

