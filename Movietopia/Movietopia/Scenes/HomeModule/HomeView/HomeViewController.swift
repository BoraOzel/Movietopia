//
//  ViewController.swift
//  Movietopia
//
//  Created by Bora Özel on 26/8/25.
//

import UIKit

protocol HomeViewControllerInterface: AnyObject,
                                      SpinnerDisplayable,
                                      AlertPresentable {
    func configureVC()
    func setCollectionViewRegister()
    func reloadCollectionView()
    func showLoading(_ show: Bool)
    func insertItems(at indexPaths: [IndexPath])
    func setCustomFlowLayout()
}

class HomeViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    lazy var viewModel: HomeViewModelInterface = HomeViewModel(view: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCollectionViewRegister()
        setCustomFlowLayout()
        configureVC()
        viewModel.viewDidLoad()
    }
}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItems()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell: MovieCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(MovieCollectionViewCell.self)",
                                                                                     for: indexPath) as? MovieCollectionViewCell
        else { return UICollectionViewCell() }
        cell.configure(data: viewModel.getItem(at: indexPath.item))
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 20
        cell.layer.borderColor = UIColor.lightGray.cgColor
        return cell
    }
}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie = viewModel.getItem(at: indexPath.item)
        
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
        }
    
    func showLoading(_ show: Bool) {
        show ? showProgress() : removeProgress()
    }
    
    func insertItems(at indexPaths: [IndexPath]) {
        collectionView.performBatchUpdates {
            collectionView.insertItems(at: indexPaths)
        }
    }
    
    func setCustomFlowLayout() {
        setCustomFlowLayout(lineSpacing: 10,
                            interItemSpacing: 10,
                            sectionInset: .zero,
                            estimatedItemSize: nil)
    }
}

extension HomeViewController: DynamicFlowLayoutCustomizable {
    typealias CustomLayout = SingleColumnDynamicHeightFlowLayout
}
