//
//  NetworkingDataSourceObserver.swift
//  UnsplashPhotoFinder
//
//  Created by Christelle Lorin on 2/8/20.
//  Copyright © 2020 Christelle Lorin. All rights reserved.
//

import Foundation

public enum NetworkDataSourceState: Equatable {
    public static func == (lhs: NetworkDataSourceState, rhs: NetworkDataSourceState) ->
        Bool {
            switch (lhs, rhs) {
            case (.ready, .ready), (.fetchData, .fetchData), (.data, .data), (.error, .error), (.empty, .empty):
                return true
            default:
                return false
            }
    }
    
    case ready
    case data
    case fetchData
    case empty
    case error(_ error: Error)
}

protocol NetworkingDataSourceDelegate: AnyObject {
    func refreshedState(state: NetworkDataSourceState)
}

protocol ViewModelDisplayDelegate: AnyObject {
    func displayData()
    func displayError(errorMessage: String)
    func displayEmpty()
}
