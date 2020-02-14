//
//  FavoritesViewModel.swift
//  UnsplashPhotoFinder
//
//  Created by Christelle Lorin on 2/10/20.
//  Copyright © 2020 Christelle Lorin. All rights reserved.
//

import Foundation

class FavoritesViewModel {
    
    // MARK: - Public
    
    public func savedFavoritedPhotos() -> [Photo]? {
        if let favoritedPhotos = UserDefaults.favoritedPhotos {
            let decoder = JSONDecoder()
            
            if let decodedPhotos = try? decoder.decode([Photo].self, from: favoritedPhotos) {
                return decodedPhotos
            }
        }
        
        return nil 
    }
    
    public func numberOfRows() -> Int? {
        guard let savedData = savedFavoritedPhotos() else { return nil }
        
        return savedData.count
    }
}
