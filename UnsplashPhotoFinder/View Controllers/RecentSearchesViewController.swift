//
//  RecentSearchesViewController.swift
//  UnsplashPhotoFinder
//
//  Created by Christelle Lorin on 2/13/20.
//  Copyright © 2020 Christelle Lorin. All rights reserved.
//

import UIKit

protocol RecentSearchesViewControllerDelegate: class {
    func recentSearchesCellWasTapped(searchTextForRow: String?)
}

class RecentSearchesViewController: UIViewController {
    
    // MARK: - Constants
    
    private struct Constants {
        static let RecentSearchesCellReuseId = "RecentSearchesTableViewCell"
        static let RecentSearchesHeader = "RecentSearchesHeaderTitle"
    }
    
    // MARK: - Properties
    
    private let viewModel = RecentSearchesViewModel()
    
    // MARK: - Delegate
    
    weak var delegate: RecentSearchesViewControllerDelegate?
    
    // MARK: - Outlets
    
    @IBOutlet private var recentSearchesTableView: UITableView!
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()
    }
    
    // MARK: - Public
    
    func reloadRecentSearches() {
        recentSearchesTableView.reloadData()
    }
    
    // MARK: - Private
    
    private func setUpView() {
        recentSearchesTableView.dataSource = self
        recentSearchesTableView.delegate = self
        recentSearchesTableView.tableFooterView = UIView(frame: .zero)
        recentSearchesTableView.tableFooterView?.backgroundColor = .systemGray
    }
}

extension RecentSearchesViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return NSLocalizedString(Constants.RecentSearchesHeader, comment: "")
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard let savedRecentSearches = viewModel.savedRecentSearches() else { return UITableViewCell() }
            let recentSearch = savedRecentSearches[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.RecentSearchesCellReuseId, for: indexPath)
            
            if let cell = cell as? RecentSearchesTableViewCell {
                cell.configure(with: recentSearch)
            }
            
            return cell
    }
}

extension RecentSearchesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {        guard let savedRecentSearches = viewModel.savedRecentSearches() else { return }
        let recentSearch = savedRecentSearches[indexPath.row]

        delegate?.recentSearchesCellWasTapped(searchTextForRow: recentSearch)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 100))
        headerView.backgroundColor = .systemGray
        
        let label = UILabel(frame: CGRect(x: 10, y: 7, width: view.frame.size.width, height: 25))
        label.text = NSLocalizedString(Constants.RecentSearchesHeader, comment: "")
        label.textColor = .systemBackground
        label.font = UIFont.init(name: "AmericanTypewriter-Bold", size: 20.0)
        headerView.addSubview(label)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
}
