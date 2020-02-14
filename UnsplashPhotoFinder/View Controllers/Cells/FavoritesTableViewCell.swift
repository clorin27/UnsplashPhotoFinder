//
//  FavoritesTableViewCell.swift
//  UnsplashPhotoFinder
//
//  Created by Christelle Lorin on 2/10/20.
//  Copyright © 2020 Christelle Lorin. All rights reserved.
//

import UIKit

class FavoritesTableViewCell: UITableViewCell {

    // MARK: - Outlets
    
    @IBOutlet private var favoritePhotoImageView: UIImageView!
    
    // MARK: - Public
    
    func configure(with photo: Photo) {
        let photoUrl = photo.urls.regular
        favoritePhotoImageView.downloadImageFromUrl(photoUrl)
    }
}
