//
//  MovieDetailViewController.swift
//  Movietopia
//
//  Created by Bora Özel on 28/8/25.
//

import UIKit

protocol MovieDetailViewControllerInterface: AnyObject {
    func configure()
}

class MovieDetailViewController: UIViewController {
    
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var viewModel: MovieDetailViewModelInterface = MovieDetailViewModel()
    var fetchedMovie: MovieResult?

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
}

extension MovieDetailViewController: MovieDetailViewControllerInterface {
    func configure() {
        let truncatedRating = floor((fetchedMovie?.voteAverage ?? 0) * 100) / 100
        let formattedRating = String(format: "%.1f", truncatedRating)
        titleLabel.text = fetchedMovie?.title
        ratingLabel.text = "⭐️\(formattedRating)"
        dateLabel.text = fetchedMovie?.releaseDate
        guard let posterPath = fetchedMovie?.posterPath else { return }
        posterImage.sd_setImage(with: URL(string: NetworkHelper.shared.requestImageurl(path: posterPath)))
        descriptionLabel.text = fetchedMovie?.overview
    }
}
