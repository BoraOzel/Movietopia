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

class MovieDetailViewController: UIViewController {
    
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    let arranger: ArgumentArrangerProtocol = ArgumentArranger()
    let networkHelper: NetworkHelperProtocol = NetworkHelper.shared
    
    var viewModel: MovieDetailViewModelInterface = MovieDetailViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension MovieDetailViewController: MovieDetailViewControllerInterface{
    func configure(data: MovieResult) {
        let vote = arranger.getFormatteddVote(vote: data.voteAverage ?? 0)
        let posterPath = data.posterPath ?? ""
        let formattedYear = arranger.formatYear(from: data.releaseDate ?? "")
        titleLabel.text = data.title
        ratingLabel.text = "⭐️\(vote)"
        dateLabel.text = formattedYear
        posterImage.sd_setImage(with: URL(string: networkHelper.requestImageurl(path: posterPath)))
        descriptionLabel.text = data.overview
    }
}
