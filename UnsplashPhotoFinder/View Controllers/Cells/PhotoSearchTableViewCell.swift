//
//  PhotoSearchTableViewCell.swift
//  UnsplashPhotoFinder
//
//  Created by Christelle Lorin on 2/9/20.
//  Copyright © 2020 Christelle Lorin. All rights reserved.
//

import UIKit

class PhotoSearchTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    private(set) var isFavorited:Bool = false
    
    private var photo: Photo?
    
    private var favoritedPhotoIds:[String] = []
    
    // MARK: - Outlets
    
    @IBOutlet private var photoImageView: UIImageView!
    
    // MARK: - Public
    
    func configure(with photo: Photo) {
        let photoUrlString = photo.urls.regular
        photoImageView.downloadImageFromUrl(photoUrlString)
    }
}
