//
//  PhotoSearchDetailViewController.swift
//  UnsplashPhotoFinder
//
//  Created by Christelle Lorin on 2/9/20.
//  Copyright © 2020 Christelle Lorin. All rights reserved.
//

import UIKit


class PhotoSearchDetailViewController: UIViewController {
    
    // MARK: - Constants
    
    private struct Constants {
        static let AlreadyLikedText = "LikeToFavoriteAlreadyLikedText"
        static let LikeThisText = "LikeToFavoriteThisPhotoText"
    }
    
    // MARK: - Instantiate
    
    static func instantiatePhotoSearchDetailVC(photo: Photo?) -> PhotoSearchDetailViewController {
        let storyboard = UIStoryboard(name: "Main", bundle:nil)
        let detailVC = storyboard.instantiateViewController(withIdentifier: "PhotoSearchDetailViewController") as! PhotoSearchDetailViewController
        detailVC.photo = photo
        
        return detailVC
    }
    
    // MARK: Properties
    
    private var photo: Photo?
    
    private var isFavorited: Bool = false
    
    private var favoritedPhotos: [Photo] = []
    private var favoritedPhotoTags: [String] = []
    private var favoritedPhotoIds: [String] = []
    
    // MARK: - Outlets
    
    @IBOutlet private var photoDetailImageView: UIImageView! {
        didSet {
            configureDetailView()
        }
    }
    @IBOutlet private var nameLabel: UILabel! {
        didSet {
            configureDetailView()
        }
    }
    @IBOutlet private var descriptionLabel: UILabel! {
        didSet {
            configureDetailView()
        }
    }
    @IBOutlet private var favoritesButton: UIButton!
    @IBOutlet private var likeToFavoriteLabel: UILabel!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let photo = photo {
            setupFavoritesButton(with: photo)
        }
        
        loadPhotos()
    }
    
    // MARK: - Actions
    
    @IBAction func favoritesButtonTapped(_ sender: Any) {
        guard let photo = photo else { return }
        updateFavorites(with: photo)
    }
    
    // MARK: - Private
    
    private func configureDetailView() {
        guard let photo = photo else { return }
        let photoUrl = photo.urls.regular
        
        if let photoDetailImageView = photoDetailImageView{
            photoDetailImageView.downloadImageFromUrl(photoUrl)
        }
        
        if let nameLabel = nameLabel {
            nameLabel.text = "By: \(photo.user.name)"
        }
        
        if let descriptionLabel = descriptionLabel {
            guard photo.description != nil else {
                descriptionLabel.text = photo.altDescription
                return
            }

            descriptionLabel.text = photo.description
        }
        
        navigationController?.navigationItem.backBarButtonItem?.tintColor = .systemBackground
    }
    
    private func updateFavorites(with photo: Photo) {
        if !isFavorited {
            favoritesButton.setImage(#imageLiteral(resourceName: "heartFilled"), for: .normal)
            likeToFavoriteLabel.text = NSLocalizedString(Constants.AlreadyLikedText, comment: "")
            isFavorited = true
            
            if let photoIds = UserDefaults.photoIds, !photoIds.contains(photo.id) {
                UserDefaults.photoIds?.append(photo.id)
                favoritedPhotos.append(photo)
                
                photo.tags.forEach { (tag) in
                    guard let photoTagTitle = tag.title else { return }
                    favoritedPhotoTags.append(photoTagTitle)
                    UserDefaults.photoTags = favoritedPhotoTags
                }
            } else if UserDefaults.photoIds == nil {
                favoritedPhotoIds.append(photo.id)
                UserDefaults.photoIds = favoritedPhotoIds
                favoritedPhotos.append(photo)
                
                photo.tags.forEach { (tag) in
                    guard let photoTagTitle = tag.title else { return }
                    favoritedPhotoTags.append(photoTagTitle)
                    UserDefaults.photoTags = favoritedPhotoTags
                }
            }
            
            storeFavoritedPhotos()
         } else {
            favoritesButton.setImage(#imageLiteral(resourceName: "heart"), for: .normal)
            likeToFavoriteLabel.text = NSLocalizedString(Constants.LikeThisText, comment: "")
            isFavorited = false
            
            let filteredIds = UserDefaults.photoIds?.filter { $0 != photo.id }
            UserDefaults.photoIds = filteredIds
            
            loadAndFilterPhotos(with: photo)
         }
    }
    
    private func setupFavoritesButton(with photo: Photo) {
        if let photoIds = UserDefaults.photoIds, photoIds.contains(photo.id) {
            likeToFavoriteLabel.text = NSLocalizedString(Constants.AlreadyLikedText, comment: "")
            favoritesButton.setImage(#imageLiteral(resourceName: "heartFilled"), for: .normal)
        } else {
            favoritesButton.setImage(#imageLiteral(resourceName: "heart"), for: .normal)
            likeToFavoriteLabel.text = NSLocalizedString(Constants.LikeThisText, comment: "")
        }
    }
    
    private func storeFavoritedPhotos() {
        let encoder = JSONEncoder()
        if let encodedPhotos = try? encoder.encode(favoritedPhotos) {
            UserDefaults.favoritedPhotos = encodedPhotos
        }
        
        favoritedPhotoTags.forEach { (tag) in
            UserDefaults.photoTags?.append(tag)
        }
    }
    
    private func loadAndFilterPhotos(with photo: Photo) {
        if let favoritedStoredPhotos = UserDefaults.favoritedPhotos {
            let decoder = JSONDecoder()
            
            if let decodedPhotos = try? decoder.decode([Photo].self, from: favoritedStoredPhotos) {
                let filteredPhotos = decodedPhotos.filter {$0.id != photo.id}
                favoritedPhotos = filteredPhotos
                
                storeFavoritedPhotos()
            }
        }
    }
    
    private func loadPhotos() {
         if let favoritedStoredPhotos = UserDefaults.favoritedPhotos {
             let decoder = JSONDecoder()
             
             if let decodedPhotos = try? decoder.decode([Photo].self, from: favoritedStoredPhotos) {
                favoritedPhotos = decodedPhotos
                 
                storeFavoritedPhotos()
             }
         }
     }
}
