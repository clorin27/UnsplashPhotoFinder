//
//  UserDefaults+Extensions.swift
//  UnsplashPhotoFinder
//
//  Created by Christelle Lorin on 2/10/20.
//  Copyright © 2020 Christelle Lorin. All rights reserved.
//

import Foundation

extension UserDefaults {
    
    public struct Keys {
        static let recentSearches = "recentSearches"
        static let photoId = "photoId"
        static let favoritedPhoto = "favoritedPhoto"
        static let photoTags = "photoTags"
    }
    
    static var recentSearches: [String]? {
        get {
            return UserDefaults.standard.array(forKey: Keys.recentSearches) as? [String]
        }
        set(favoritedPhotoIds) {
            UserDefaults.standard.set(favoritedPhotoIds, forKey: Keys.recentSearches)
        }
    }
    
    static var photoIds: [String]? {
        get {
            return UserDefaults.standard.array(forKey: Keys.photoId) as? [String]
        }
        set(favoritedPhotoIds) {
            UserDefaults.standard.set(favoritedPhotoIds, forKey: Keys.photoId)
        }
    }
    
    static var favoritedPhotos: Data? {
        get {
            return UserDefaults.standard.data(forKey: Keys.favoritedPhoto) 
        }
        set (usersFavoritedPhoto) {
            UserDefaults.standard.set(usersFavoritedPhoto, forKey: Keys.favoritedPhoto)
        }
    }
    
    static var photoTags: [String]? {
        get {
            return UserDefaults.standard.array(forKey: Keys.photoTags) as? [String]
        }
        set(favoritedPhotoIds) {
            UserDefaults.standard.set(favoritedPhotoIds, forKey: Keys.photoTags)
        }
    }
}
