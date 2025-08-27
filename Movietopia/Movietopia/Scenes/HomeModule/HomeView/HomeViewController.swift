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
        
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let threshold = max(0, viewModel.movieItems.count - 5)
           if indexPath.item >= threshold {
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
}

extension HomeViewController: DynamicFlowLayoutCustomizable {
    typealias CustomLayout = SingleColumnDynamicHeightFlowLayout
}
