//
//  FavoritesDetailViewController.swift
//  UnsplashPhotoFinder
//
//  Created by Christelle Lorin on 2/13/20.
//  Copyright © 2020 Christelle Lorin. All rights reserved.
//

import UIKit

class FavoritesDetailViewController: UIViewController {
    
    // MARK: - Instantiate
    
    static func instantiateFavoritesDetailVC(photo: Photo?) -> FavoritesDetailViewController {
        let storyboard = UIStoryboard(name: "Main", bundle:nil)
        let detailVC = storyboard.instantiateViewController(withIdentifier: "FavoritesDetailViewController") as! FavoritesDetailViewController
        detailVC.photo = photo
        
        return detailVC
    }
    
    // MARK: - Properties
    
    private var photo: Photo?
    
    // MARK: - Outlets
    
    @IBOutlet private var favoritedPhotoImageView: UIImageView! {
        didSet {
            configureFavoritesDetailView()
        }
    }
    @IBOutlet private var userLabel: UILabel! {
        didSet {
            configureFavoritesDetailView()
        }
    }
    @IBOutlet private var descriptionLabel: UILabel! {
        didSet {
            configureFavoritesDetailView()
        }
    }
    
    // MARK: - Private
    
    private func configureFavoritesDetailView() {
        guard let photo = photo else { return }
        let photoUrl = photo.urls.regular
        
        if let favoritedPhotoImageView = favoritedPhotoImageView {
            favoritedPhotoImageView.downloadImageFromUrl(photoUrl)
        }
        
        if let userLabel = userLabel {
            userLabel.text = "By: \(photo.user.name)"
        }
        
        if let descriptionLabel = descriptionLabel {
            guard photo.description != nil else {
                descriptionLabel.text = photo.altDescription
                return
            }
            
            descriptionLabel.text = photo.description
        }
    }
}
