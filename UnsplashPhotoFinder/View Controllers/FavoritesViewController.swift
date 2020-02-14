//
//  FavoritesViewController.swift
//  UnsplashPhotoFinder
//
//  Created by Christelle Lorin on 2/10/20.
//  Copyright © 2020 Christelle Lorin. All rights reserved.
//

import UIKit

class FavoritesViewController: UIViewController {
    
    // MARK: - Constants
    
    private struct Constants {
        static let FavoritesCellReuseId = "FavoritesTableViewCell"
        static let FavoritePhotosTitle = "FavoritePhotosTitle"
    }
    
    // MARK: - Properties
    
    private let viewModel = FavoritesViewModel()
    
    private let refreshControl = UIRefreshControl()
    
    // MARK: - Outlets
    
    @IBOutlet private var favoritesTableView: UITableView!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        favoritesTableView.reloadData()
    }
    
    // MARK: - Private
    
    private func setUpView() {
        favoritesTableView.dataSource = self
        favoritesTableView.delegate = self
        favoritesTableView.tableFooterView = UIView(frame: .zero)
        
        title = NSLocalizedString(Constants.FavoritePhotosTitle, comment: "")
        
        addRefreshControl()
    }
    
    // MARK: UIRefreshControl

    private func addRefreshControl() {
        favoritesTableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(endRefreshing), for: .valueChanged)

        favoritesTableView.addSubview(refreshControl)
    }

    @objc private func endRefreshing() {
        refreshControl.endRefreshing()
    }
}

// MARK: Table View Data Source

extension FavoritesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let numberOfRows = viewModel.numberOfRows() else { return 0 }
        
        return numberOfRows
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let photo = viewModel.savedFavoritedPhotos()?[indexPath.row] else { return UITableViewCell() }
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.FavoritesCellReuseId, for: indexPath)

        if let cell = cell as? FavoritesTableViewCell {
            cell.configure(with: photo)
        }

        return cell
    }
}

// MARK: Table View Delegate

extension FavoritesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.layer.cornerRadius = 10.0
        cell.layer.masksToBounds = true
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let data = viewModel.savedFavoritedPhotos(), data.count > 0 else { return }
        let photo = data[indexPath.row]
        let detailVC = FavoritesDetailViewController.instantiateFavoritesDetailVC(photo: photo)
        
        tableView.deselectRow(at: indexPath, animated: true)
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
