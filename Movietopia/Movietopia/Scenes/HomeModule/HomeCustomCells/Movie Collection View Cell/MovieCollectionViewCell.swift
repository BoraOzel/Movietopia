//
//  MovieCollectionViewCell.swift
//  Movietopia
//
//  Created by Bora Özel on 26/8/25.
//

import UIKit

final class MovieCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var movieImage: UIImageView!
    @IBOutlet private weak var movieNameLabel: UILabel!
    @IBOutlet private weak var releaseDateLabel: UILabel!
    @IBOutlet private weak var voteLabel: UILabel!
    
    let networkHelper: NetworkHelperProtocol = NetworkHelper.shared
    
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
        movieNameLabel.text = data.title
        releaseDateLabel.text = "🗓️\(data.releaseDate?.toFormattedYear() ?? "-")"
        movieImage.sd_setImage(with: URL(string: "\(NetworkEndPoint.baseImageUrl.rawValue)\(data.posterPath ?? "")"))
        voteLabel.text = "⭐️\(data.voteAverage?.toFormattedVote() ?? "-")"
    }
    
    func setCellBorder(cell: UICollectionViewCell) {
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 20
        cell.layer.borderColor = UIColor.lightGray.cgColor
    }

}
