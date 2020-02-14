//
//  UIImageView+Extensions.swift
//  UnsplashPhotoFinder
//
//  Created by Christelle Lorin on 2/9/20.
//  Copyright © 2020 Christelle Lorin. All rights reserved.
//

import UIKit

extension UIImageView {

    func cacheImages(with url: String) -> UIImage? {
        let cache = NSCache<NSString, UIImage>()
        let key =  url

        let cachedPhotos = cache.object(forKey: NSString(string:key))

        return cachedPhotos
    }

    func downloadImageFromUrl(_ url: String) {
        guard let imageUrl = URL(string:url) else { return }

        if let cachedImage = cacheImages(with: url) {
            self.image = cachedImage
            return
        }

        URLSession.shared.dataTask(with: imageUrl, completionHandler: { (data, response, error) in
            if let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200, let data = data, error == nil, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.image = image
                }
            } 
        }).resume()
    }
}
