//
//  RecentASearchesTableViewCell.swift
//  UnsplashPhotoFinder
//
//  Created by Christelle Lorin on 2/13/20.
//  Copyright © 2020 Christelle Lorin. All rights reserved.
//

import UIKit

class RecentSearchesTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet private var recentSearchLabel: UILabel!
    
    // MARK: - Public
    
    func configure(with recentSearch: String?) {
        if let recentSearch = recentSearch {
            recentSearchLabel.text = recentSearch
        }
    }
}
