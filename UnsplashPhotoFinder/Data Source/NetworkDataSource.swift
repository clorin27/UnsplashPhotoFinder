//
//  NetworkDataSource.swift
//  UnsplashPhotoFinder
//
//  Created by Christelle Lorin on 2/8/20.
//  Copyright © 2020 Christelle Lorin. All rights reserved.
//

import Foundation
import UIKit

final class NetworkDataSource: LoadableDataSource {

    // MARK: - Constants

    var query: String?

    var error: HTTPURLResponse?

    // MARK: - Properties

    private var stateMachine: StateMachine<NetworkDataSource>!

    var data: [Photo]?
    var delegate: NetworkingDataSourceDelegate?

    // MARK: - Initialization
    init() {
        stateMachine = StateMachine(initialState: .ready, delegate: self)
    }

    // MARK: - Base States

    func refresh() {
        stateMachine.state = .fetchData
    }

    func empty() {
        data?.removeAll()
    }

    func fetchData() {
        loadData(page: 1, perPage: 24) { [weak self] result in
            switch result {
            case .success:
                self?.stateMachine.state = .data
            case .empty:
                self?.stateMachine.state = .empty
            case .failure(let error):
                print("Network State Machine error = \(error.localizedDescription)")
                self?.stateMachine.state = .error(error)
            }
        }
    }

    func loadData(page: Int, perPage: Int, completion: @escaping ((LoadResult) -> Void)) {
        guard let query = query, let url = URL(string: UnsplashAPI.EndPoint.search(query: query, page: page, perPage: perPage)) else { return }
        let request = URLRequest(url: url)

        URLSession.shared.dataTask(with: request) { data, response, error in
            do {
                guard let data = data, let _ = response, error == nil else {
                    if let error = error {
                        let result = self.createLoadResult(error: error, empty: false)

                        completion(result)
                    }
                    return
                }

                let decoder = JSONDecoder()
                let searchResponse = try decoder.decode(SearchResults.self, from: data)

                self.data = searchResponse.results
                let result = self.createLoadResult(error: nil, empty: searchResponse.results.isEmpty)
                completion(result)
            } catch {
                print(error)
            }
        }.resume()
    }

    func refreshStateObserver(newState: NetworkDataSourceState) {
        delegate?.refreshedState(state: newState)
    }
}

// MARK: - State Machine Protocol

extension NetworkDataSource: StateMachineDelegateProtocol {

    func shouldTransition(from: NetworkDataSourceState, to: NetworkDataSourceState) -> Bool {
        guard from != to else {
            return false
        }

        return true
    }

    func didTransition(from: NetworkDataSourceState, to: NetworkDataSourceState) {
        switch (from, to) {
        case (_, .fetchData):
            fetchData()
        case (_, .data):
            refreshStateObserver(newState: to)
        case (_, .error):
            refreshStateObserver(newState: to)
        case (_, .empty):
            refreshStateObserver(newState: to)
        default:
            break
        }
    }
}
