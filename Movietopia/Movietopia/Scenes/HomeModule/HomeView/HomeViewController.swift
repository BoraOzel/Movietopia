//
//  ViewController.swift
//  Movietopia
//
//  Created by Bora Özel on 26/8/25.
//

import UIKit

protocol HomeViewControllerInterface: AnyObject, SpinnerDisplayable {
    func configureVC()
    func setCollectionViewRegister()
    func reloadCollectionView()
    func showCantGetDataError()
    func insertItems(at indexPaths: [IndexPath])
    func reloadSection(_ section: Int)
}

class HomeViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let viewModel = HomeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCustomFlowLayout(lineSpacing: 10,
                            interItemSpacing: 10,
                            sectionInset: .zero,
                            estimatedItemSize: nil)
        configureVC()
        setCollectionViewRegister()
        Task {
            showProgress()
            viewModel.viewDidLoad()
            collectionView.reloadData()
            removeProgress()
        }
        showCantGetDataError()
    }
}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.movieItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell: MovieCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(MovieCollectionViewCell.self)",
                                                                                     for: indexPath) as? MovieCollectionViewCell
        else { return UICollectionViewCell() }
        cell.configure(data: viewModel.movieItems[indexPath.item])
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 20
        cell.layer.borderColor = UIColor.lightGray.cgColor
        return cell
    }
}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie = viewModel.movieItems[indexPath.item]

        let storyboard = UIStoryboard(name: "MovieDetail", bundle: nil)
        guard let detailVC = storyboard.instantiateViewController(withIdentifier: "MovieDetailViewController")
                as? MovieDetailViewController else {
            assertionFailure("Couldn't find Movie Detail View Controller.")
            return
        }
        detailVC.fetchedMovie = movie
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.size.height
        
        if offsetY > contentHeight - frameHeight * 1.1 {
            Task { await viewModel.getMovies() }
        }
    }
}

extension HomeViewController: HomeViewControllerInterface {
    func setCollectionViewRegister() {
        collectionView.register(UINib(nibName: "\(MovieCollectionViewCell.self)", bundle: nil),
                                forCellWithReuseIdentifier: "MovieCollectionViewCell")
    }
    
    func reloadCollectionView() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    func configureVC() {
        viewModel.view = self
    }
    
    func showCantGetDataError() {
        viewModel.onError = { [weak self] title, message in
            guard let self = self else { return }
            DispatchQueue.main.async {
                AlertHelper.showAlert(on: self,
                                      title: title,
                                      message: message,
                                      buttonTitle: "Retry")
            }
        }
    }
    
    func insertItems(at indexPaths: [IndexPath]) {
        collectionView.performBatchUpdates {
            collectionView.insertItems(at: indexPaths)
        }
    }
    
    func reloadSection(_ section: Int) {
        collectionView.reloadSections(IndexSet(integer: section))
    }
}

extension HomeViewController: DynamicFlowLayoutCustomizable {
    typealias CustomLayout = SingleColumnDynamicHeightFlowLayout
}
