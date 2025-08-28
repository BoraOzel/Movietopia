//
//  MovieDetailViewController.swift
//  Movietopia
//
//  Created by Bora Özel on 28/8/25.
//

import UIKit

protocol MovieDetailViewControllerInterface: AnyObject,
                                             SpinnerDisplayable{
    func configureView()
}

class MovieDetailViewController: UIViewController {
    
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var fetchedMovie: MovieResult?
    let baseImageUrl = "https://image.tmdb.org/t/p/w500/"
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
}

extension MovieDetailViewController: MovieDetailViewControllerInterface {
    
    func configureView() {
        let truncatedRating = floor((fetchedMovie?.voteAverage ?? 0) * 100) / 100
        let formattedRating = String(format: "%.1f", truncatedRating)
        titleLabel.text = fetchedMovie?.title
        ratingLabel.text = "⭐️\(formattedRating)"
        dateLabel.text = fetchedMovie?.releaseDate
        guard let posterPath = fetchedMovie?.posterPath else { return }
        posterImage.sd_setImage(with: URL(string: "\(baseImageUrl)\(posterPath)"))
        descriptionLabel.text = fetchedMovie?.overview
    }
}
