//
//  ViewController.swift
//  Movietopia
//
//  Created by Bora Özel on 26/8/25.
//

import UIKit

protocol HomeViewControllerInterface: AnyObject {
    func configureVC()
}

class HomeViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let viewModel = HomeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.view = self
        setCustomFlowLayout(lineSpacing: 10,
                            interItemSpacing: 0,
                            sectionInset: .zero,
                            estimatedItemSize: .zero)
        configureVC()
        Task{ viewModel.viewDidLoad() }
    }
}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.movieItems.count + (viewModel.isLoading ? 1 : 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row < viewModel.movieItems.count {
            let cell: MovieCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(MovieCollectionViewCell.self)",
                                                                                   for: indexPath) as! MovieCollectionViewCell
            cell.configure(data: viewModel.movieItems[indexPath.item])
            cell.layer.borderWidth = 1
            cell.layer.cornerRadius = 20
            cell.layer.borderColor = UIColor.lightGray.cgColor
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(MovieLoadingCollectionViewCell.self)",
                                                          for: indexPath) as! MovieLoadingCollectionViewCell
            return cell
        }
    }
}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard !viewModel.isLoading else { return }

        let y = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let h = scrollView.frame.size.height

        if y > contentHeight - h * 1.1 {   // alta %10 kala
            Task { await viewModel.getMovies() }
        }
    }
}

extension HomeViewController: HomeViewControllerInterface {
    func configureVC() {
        collectionView.register(UINib(nibName: "\(MovieCollectionViewCell.self)", bundle: nil),
                                forCellWithReuseIdentifier: "MovieCollectionViewCell")
        collectionView.register(UINib(nibName: "\(MovieLoadingCollectionViewCell.self)", bundle: nil),
                                forCellWithReuseIdentifier: "MovieLoadingCollectionViewCell")
    }
}

extension HomeViewController: DynamicFlowLayoutCustomizable {
    typealias CustomLayout = SingleColumnDynamicHeightFlowLayout
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ cv: UICollectionView,
                        layout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let w = cv.bounds.width
        // Loader hücresi son eleman
        if indexPath.item == viewModel.movieItems.count && viewModel.isLoading {
            return CGSize(width: w, height: 60)
        }
        // Film kartı (örnek tek kolon)
        return CGSize(width: w, height: 220)
    }
}
