//
//  PhotoSearchNavigationController.swift
//  UnsplashPhotoFinder
//
//  Created by Christelle Lorin on 2/14/20.
//  Copyright © 2020 Christelle Lorin. All rights reserved.
//

import UIKit

class PhotoSearchNavigationController: UINavigationController {
    
    // MARK: - Outlets

    @IBOutlet private var searchTabBarItem: UITabBarItem!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchTabBarItem.badgeColor = .systemBackground
    }
}
