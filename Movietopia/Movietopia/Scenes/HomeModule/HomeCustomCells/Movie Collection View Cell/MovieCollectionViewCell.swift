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
        guard let posterPath = data.posterPath else { return }
        
        movieNameLabel.text = data.title
        releaseDateLabel.text = "🗓️\(formatYear(from: data.releaseDate ?? ""))"
        movieImage.sd_setImage(with: URL(string: NetworkHelper.shared.requestImageurl(path: posterPath)))
        voteLabel.text = "⭐️\(formattedVote)"
    }
    
    func formatYear(from dateString: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"

        guard let date = inputFormatter.date(from: dateString) else {
            return "-"
        }

        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "yyyy"
        return outputFormatter.string(from: date)
    }
}
