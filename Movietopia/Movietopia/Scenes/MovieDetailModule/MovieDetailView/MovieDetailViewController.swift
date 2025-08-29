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
    
    let arranger: ArgumentArrangerProtocol = ArgumentArranger()
    let networkHelper: NetworkHelperProtocol = NetworkHelper.shared
    
    var viewModel: MovieDetailViewModelInterface = MovieDetailViewModel()
    var fetchedMovie: MovieResult?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
}

extension MovieDetailViewController: MovieDetailViewControllerInterface {
    func configure() {
        let vote = arranger.getFormatteddVote(vote: fetchedMovie?.voteAverage ?? 0)
        let posterPath = fetchedMovie?.posterPath ?? ""
        let formattedYear = arranger.formatYear(from: fetchedMovie?.releaseDate ?? "")
        titleLabel.text = fetchedMovie?.title
        ratingLabel.text = "⭐️\(vote)"
        dateLabel.text = formattedYear
        posterImage.sd_setImage(with: URL(string: networkHelper.requestImageurl(path: posterPath)))
        descriptionLabel.text = fetchedMovie?.overview
    }
}
