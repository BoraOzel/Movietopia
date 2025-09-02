//
//  MovieDetailViewController.swift
//  Movietopia
//
//  Created by Bora Özel on 28/8/25.
//

import UIKit

protocol MovieDetailViewControllerInterface: AnyObject {
    func configure(data: MovieResult)
}

final class MovieDetailViewController: UIViewController {
    
    @IBOutlet private weak var posterImage: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var ratingLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    
    let networkHelper: NetworkHelperProtocol = NetworkHelper.shared
    
    var viewModel: MovieDetailViewModelInterface = MovieDetailViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension MovieDetailViewController: MovieDetailViewControllerInterface{
    func configure(data: MovieResult) {
        titleLabel.text = data.title
        ratingLabel.text = "⭐️\(data.voteAverage?.toFormattedVote() ?? "-")"
        dateLabel.text = data.releaseDate?.toFormattedYear()
        posterImage.sd_setImage(with: URL(string: networkHelper.requestImageurl(path: data.posterPath ?? "")))
        descriptionLabel.text = data.overview
    }
}
