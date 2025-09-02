//
//  ViewController.swift
//  Movietopia
//
//  Created by Bora Özel on 26/8/25.
//

import UIKit

protocol HomeViewItems: AlertPresentable,
                        SpinnerDisplayable
{}

typealias HomeViewKit = HomeViewItems

protocol HomeViewControllerInterface: AnyObject,
                                      HomeViewKit {
    func configureVC()
    func setCollectionViewRegister()
    func reloadCollectionView()
    func showLoading(_ show: Bool)
    func insertItems(at indexPaths: [IndexPath])
    func setCustomFlowLayout()
    func loadDetailVC() -> MovieDetailViewController
    func navigateToDetail(vc: UIViewController)
}

final class HomeViewController: UIViewController {
    
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
        guard let item = viewModel.getItem(at: indexPath.item) else { return UICollectionViewCell() }
        cell.configure(data: item)
        cell.setCellBorder(cell: cell)
        return cell
    }
}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailVC = loadDetailVC()
        guard let item = viewModel.getItem(at: indexPath.item) else { return }
        detailVC.configure(data: item)
        navigateToDetail(vc: detailVC)
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
    
    func loadDetailVC() -> MovieDetailViewController {
        let storyboard = UIStoryboard(name: "MovieDetail", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "MovieDetailViewController") as! MovieDetailViewController
        vc.loadViewIfNeeded()
        return vc
    }
    
    func navigateToDetail(vc: UIViewController) {
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension HomeViewController: DynamicFlowLayoutCustomizable {
    typealias CustomLayout = SingleColumnDynamicHeightFlowLayout
}
