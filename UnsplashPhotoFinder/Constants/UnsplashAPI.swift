//
//  UnsplashAPI.swift
//  UnsplashPhotoFinder
//
//  Created by Christelle Lorin on 2/8/20.
//  Copyright © 2020 Christelle Lorin. All rights reserved.
//

import Foundation

struct UnsplashAPI {
    
    struct Host {
        static let search = "https://api.unsplash.com"
    }
    
    struct Paths {
        static let search = "/search/photos?"
    }
    
    struct Configuration {
        static let accessKey = "33d6a737ded40e4dc8cd1472024e6a8c8693f7577bee67717a71c4c61d42ede7"
    }
    
    struct EndPoint {
        static func search(query: String, page: Int, perPage: Int) -> String {
            return Host.search + Paths.search + "query=\(query)&" + "client_id=\(Configuration.accessKey)"
        }
    }
}
