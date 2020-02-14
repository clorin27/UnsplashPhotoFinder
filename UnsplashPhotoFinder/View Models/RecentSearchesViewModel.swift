//
//  RecentSearchesViewModel.swift
//  UnsplashPhotoFinder
//
//  Created by Christelle Lorin on 2/13/20.
//  Copyright © 2020 Christelle Lorin. All rights reserved.
//

import Foundation

class RecentSearchesViewModel {

    // MARK: - Public
    
    func savedRecentSearches() -> [String]? {
        guard let recentSearches = UserDefaults.recentSearches else { return [] }
        
        return recentSearches
    }
    
    func numberOfRows() -> Int {
        guard let savedRecentSearches = savedRecentSearches() else { return 0 }
        
        return savedRecentSearches.count
    }
}
