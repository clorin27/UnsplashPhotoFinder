//
//  PhotoSearchViewModel.swift
//  UnsplashPhotoFinder
//
//  Created by Christelle Lorin on 2/9/20.
//  Copyright © 2020 Christelle Lorin. All rights reserved.
//

import Foundation
import UIKit

class PhotoSearchViewModel {

    // MARK: - Properties

    private let dataSource = NetworkDataSource()
    var delegate: ViewModelDisplayDelegate?

    init() {
        dataSource.delegate = self
    }

    // MARK: - Public

    public func data() -> [Photo]? {
        return dataSource.data
    }

    public func refresh(query: String?) {
        if let query = query {
            dataSource.query = query
        }

        dataSource.refresh()
    }

    public func empty() {
        dataSource.empty()
    }

    public func query() -> String? {
        return dataSource.query
    }
    
    public func numberOfRows() -> Int? {
        guard let data = dataSource.data else { return nil }

        return data.count
    }
    
    public func estimatedHeight() -> CGFloat? {
        return 100.0
    }
}

extension PhotoSearchViewModel: NetworkingDataSourceDelegate {
    func refreshedState(state: NetworkDataSourceState) {
        switch state {
        case .data:
            delegate?.displayData()
        case .empty:
            delegate?.displayEmpty()
        case .error(let error):
            delegate?.displayError(errorMessage: error.localizedDescription )
        default:
            break
        }
    }
}
