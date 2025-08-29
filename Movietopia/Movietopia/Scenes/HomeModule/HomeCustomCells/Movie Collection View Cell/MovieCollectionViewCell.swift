//
//  MovieCollectionViewCell.swift
//  Movietopia
//
//  Created by Bora Özel on 26/8/25.
//

import UIKit

class MovieCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var movieImage: UIImageView!
    @IBOutlet private weak var movieNameLabel: UILabel!
    @IBOutlet private weak var releaseDateLabel: UILabel!
    @IBOutlet private weak var voteLabel: UILabel!
    
    let networkHelper: NetworkHelperProtocol = NetworkHelper.shared
    
    private var gradientLayer: CAGradientLayer?
    var arranger: ArgumentArrangerProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let targetSize = CGSize(width: layoutAttributes.frame.width,
                                height: UIView.layoutFittingExpandedSize.height)
        layoutAttributes.frame.size =
        contentView.systemLayoutSizeFitting(targetSize,
                                            withHorizontalFittingPriority: .required,
                                            verticalFittingPriority: .fittingSizeLevel)
        return layoutAttributes
    }
    
    func configure(data: MovieResult) {
        guard let vote = arranger?.getFormatteddVote(vote: data.voteAverage ?? 0) else { return }
        guard let posterPath = data.posterPath else { return }
        guard let formattedYear = arranger?.formatYear(from: data.releaseDate ?? "") else { return }
        
        movieNameLabel.text = data.title
        releaseDateLabel.text = "🗓️\(formattedYear)"
        movieImage.sd_setImage(with: URL(string: networkHelper.requestImageurl(path: posterPath)))
        voteLabel.text = "⭐️\(vote)"
    }
    
    func setCellBorder(cell: UICollectionViewCell) {
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 20
        cell.layer.borderColor = UIColor.lightGray.cgColor
    }

    func setRadiusForPoster() {
        movieImage.layer.cornerRadius = 12
        movieImage.layer.masksToBounds = true
    }
}
