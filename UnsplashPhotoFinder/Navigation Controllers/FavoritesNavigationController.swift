//
//  FavoritesNavigationController.swift
//  UnsplashPhotoFinder
//
//  Created by Christelle Lorin on 2/14/20.
//  Copyright © 2020 Christelle Lorin. All rights reserved.
//

import UIKit

class FavoritesNavigationController: UINavigationController {
    
    // MARK: - Outlets
    
    @IBOutlet private var favoritesTabBarItem: UITabBarItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        favoritesTabBarItem.badgeColor = .systemBackground
    }
}
