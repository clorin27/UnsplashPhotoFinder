//
//  PhotoSearchViewController.swift
//  UnsplashPhotoFinder
//
//  Created by Christelle Lorin on 2/8/20.
//  Copyright © 2020 Christelle Lorin. All rights reserved.
//

import UIKit

class PhotoSearchViewController: UIViewController {
        
    // MARK: - Constants
    
    private struct Constants {
        static let PhotoCellReuseId = "PhotoSearchTableViewCell"
        
        static let AlertErrorTitle = "AlertErrorTitle"
        static let AlertEmptyTitle = "AlertEmptyTitle"
        static let DismissAction = "DismissAction"
        
        static let SearchBarPlaceholder = "SearchBarPlaceholder"
        
        static let RecentSearchesMax = 5
    }
    
    private struct Segues {
        static let RecentSearches = "RecentSearchesSegue"
    }
    
    // MARK: - Properties
    
    private var recentSearches: [String] = []
    
    private var recentSearchesViewController = RecentSearchesViewController()

    private let viewModel = PhotoSearchViewModel()
    
    private let searchController = UISearchController()
    private let refreshControl = UIRefreshControl()
    
    
    // MARK: - Outlets
    
    @IBOutlet private var photoTableView: UITableView!
    @IBOutlet private var emptyView: UIView!
    @IBOutlet weak var emptyViewLabel: UILabel!
    @IBOutlet private var recentSearchesContainerView: UIView!
    
    // MARK: - Lifecycle
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segues.RecentSearches {
            recentSearchesViewController = segue.destination as! RecentSearchesViewController
            recentSearchesViewController.delegate = self 
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()
    }
    
    // MARK: - Private

    private func setUpView() {
        photoTableView.delegate = self
        photoTableView.dataSource = self

        viewModel.delegate = self

        addRefreshControl()
        createSearchController()
        
        if UserDefaults.recentSearches == nil {
            photoTableView.isHidden = true
            recentSearchesContainerView.isHidden = true
            emptyView.isHidden = false
        } else {
            photoTableView.isHidden = true
            recentSearchesContainerView.isHidden = false
            emptyView.isHidden = true
        }
    }
    
    private func updateRecentSearches(with searchText: String?) {
        guard let searchText = searchText, searchText != "" else { return }
        
        if recentSearches.isEmpty && UserDefaults.recentSearches == nil {
            recentSearches.append(searchText)
            UserDefaults.recentSearches = recentSearches
            recentSearchesViewController.reloadRecentSearches()
        } else if recentSearches.isEmpty, let savedRecentSearches = UserDefaults.recentSearches {
            recentSearches = savedRecentSearches
            recentSearchesViewController.reloadRecentSearches()
        } else {
            if recentSearches.contains(searchText), let index = recentSearches.firstIndex(of: searchText) {
                recentSearches.remove(at: index)
            }
            
            recentSearches.insert(searchText, at: 0)
            
            if recentSearches.count == Constants.RecentSearchesMax + 1 {
                recentSearches.remove(at: Constants.RecentSearchesMax)
            }
            
            // filter empty string searches
            let filteredRecentSearches = recentSearches.filter { $0 != "" }
            
            UserDefaults.recentSearches = filteredRecentSearches
            recentSearchesViewController.reloadRecentSearches()
        }
    }
    
    private func autoCompleteTextWithTags( in textField: UITextField, using searchText: String, suggestions: [String]) -> Bool {
        if !searchText.isEmpty,
            let selectedTextRange = textField.selectedTextRange, selectedTextRange.end == textField.endOfDocument,
            let prefixRange = textField.textRange(from: textField.beginningOfDocument, to: selectedTextRange.start),
            let text = textField.text( in : prefixRange) {
            let prefix = text + searchText
            let matches = suggestions.filter {
                $0.hasPrefix(prefix)
            }
           
            if (matches.count > 0) {
                textField.text = matches[0]
                if let start = textField.position(from: textField.beginningOfDocument, offset: prefix.count) {
                    textField.selectedTextRange = textField.textRange(from: start, to: textField.endOfDocument)
                    return true
                }
            }
        }
        
        return false
    }
    
    
    private func showCorrectViewIfTextIsClearedOrCancelled() {
        photoTableView.isHidden = true
        
        if recentSearches.isEmpty && UserDefaults.recentSearches == nil {
            emptyView.isHidden = false
            recentSearchesContainerView.isHidden = true
            viewModel.empty()
            photoTableView.reloadData()
        } else {
            emptyView.isHidden = true
            recentSearchesContainerView.isHidden = false
            embedViewController(recentSearchesViewController, in: recentSearchesContainerView)
            photoTableView.reloadData()
        }
    }

    // MARK: UIRefreshControl

    private func addRefreshControl() {
        photoTableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)

        photoTableView.addSubview(refreshControl)
    }

    @objc private func refresh() {
        viewModel.refresh(query: viewModel.query())
    }

    // MARK: UISearchController

    private func createSearchController() {
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.searchBar.searchTextField.delegate = self

        searchController.searchBar.tintColor = .systemBackground
        searchController.searchBar.barTintColor = .systemBackground
        searchController.searchBar.backgroundColor = .systemGray
        searchController.searchBar.placeholder = NSLocalizedString(Constants.SearchBarPlaceholder, comment: "")
        searchController.searchBar.searchTextField.autocapitalizationType = .none
        searchController.searchBar.searchTextField.backgroundColor = .systemGray3
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false

        navigationItem.titleView = searchController.searchBar

        definesPresentationContext = true
    }
}

// MARK: - Search Results Updater

extension PhotoSearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text,
            searchText.isEmpty == false else {
                showCorrectViewIfTextIsClearedOrCancelled()
                return
        }
        
        viewModel.refresh(query: searchText)
    }
}

// MARK: - Search Bar Delegate

extension PhotoSearchViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        recentSearchesContainerView.isHidden = true
        emptyView.isHidden = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else { return }
        updateRecentSearches(with: searchText)
        viewModel.refresh(query: searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        showCorrectViewIfTextIsClearedOrCancelled()
    }
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if let photoTags = UserDefaults.photoTags {
            return !autoCompleteTextWithTags(in: searchBar.searchTextField, using: text, suggestions: photoTags)
        }

        return true
    }
}

// MARK: - Text Field Delegate

extension PhotoSearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: - Table View Data Source

extension PhotoSearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let numberOfRows = viewModel.numberOfRows() else { return 0 }
        
        return numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let data = viewModel.data() else { return UITableViewCell() }
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.PhotoCellReuseId, for: indexPath)
        let photo = data[indexPath.row]
        
        if let cell = cell as? PhotoSearchTableViewCell {
            cell.configure(with: photo)
        }
        
        return cell
    }
}

// MARK: - Table View Delegate

extension PhotoSearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.layer.cornerRadius = 10.0
        cell.layer.masksToBounds = true 
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let data = viewModel.data(), data.count > 0 else { return }
        let photo = data[indexPath.row]
        let detailVC = PhotoSearchDetailViewController.instantiatePhotoSearchDetailVC(photo: photo)
        
        tableView.deselectRow(at: indexPath, animated: true)
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
                return 80
    }
}

// MARK: - Recent Search View Controller Delegate

extension PhotoSearchViewController: RecentSearchesViewControllerDelegate {
    func recentSearchesCellWasTapped(searchTextForRow: String?) {
        guard let searchTextForRow = searchTextForRow else { return }
        
        searchController.searchBar.text = searchTextForRow
    }
}

// MARK: - View Model Display Delegate

extension PhotoSearchViewController: ViewModelDisplayDelegate {
    func displayError(errorMessage: String) {
        DispatchQueue.main.async { [weak self] in
            let alertController = UIAlertController(title: NSLocalizedString(Constants.AlertErrorTitle, comment: ""), message: errorMessage, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: NSLocalizedString(Constants.DismissAction, comment: ""), style: .cancel, handler: nil))
            self?.present(alertController, animated: false, completion: nil)
        }
    }

    func displayData() {
        DispatchQueue.main.async { [weak self] in
            self?.photoTableView.isHidden = false
            self?.emptyView.isHidden = true
            self?.recentSearchesContainerView.isHidden = true

            if self?.refreshControl.isRefreshing == true {
                self?.refreshControl.endRefreshing()
            }
            
            self?.photoTableView.reloadData()
        }
    }

    func displayEmpty() {
        DispatchQueue.main.async { [weak self] in
            self?.photoTableView.isHidden = true
            
            if self?.recentSearches.isEmpty ?? true {
                self?.emptyView.isHidden = false
                self?.photoTableView.isHidden = true
                self?.recentSearchesContainerView.isHidden = true
            } else if let recentSearchesViewController = self?.recentSearchesViewController, let recentSearchesContainerView = self?.recentSearchesContainerView {
                self?.emptyView.isHidden = true
                self?.photoTableView.isHidden = true
                self?.recentSearchesContainerView.isHidden = false
                self?.embedViewController(recentSearchesViewController, in: recentSearchesContainerView)
            }

            let alertController = UIAlertController(title: NSLocalizedString(Constants.AlertEmptyTitle, comment: ""), message: "", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: NSLocalizedString(Constants.DismissAction, comment: ""), style: .cancel, handler: nil))
            self?.present(alertController, animated: false, completion: nil)
        }
    }
}
