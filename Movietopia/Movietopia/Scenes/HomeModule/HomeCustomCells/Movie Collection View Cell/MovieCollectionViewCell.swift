//
//  MovieCollectionViewCell.swift
//  Movietopia
//
//  Created by Bora Özel on 26/8/25.
//

import UIKit

class MovieCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var movieNameLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var voteLabel: UILabel!
    
    
    let baseImageUrl = "https://image.tmdb.org/t/p/w500/"
    
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
        let truncatedVote = floor((data.voteAverage ?? 0) * 100) / 100
        let formattedVote = String(format: "%.1f", truncatedVote)
        movieNameLabel.text = data.title
        releaseDateLabel.text = "🗓️\(data.releaseDate!)"
        guard let posterPath = data.posterPath else { return }
        movieImage.sd_setImage(with: URL(string: "\(baseImageUrl)\(posterPath)"))
        voteLabel.text = "⭐️\(formattedVote)"
    }
    
}
