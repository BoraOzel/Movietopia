//
//  MovieLoadingCollectionViewCell.swift
//  Movietopia
//
//  Created by Bora Özel on 27/8/25.
//

import UIKit

class MovieLoadingCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var loadingSpinner: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        loadingSpinner.startAnimating()
    }
}
