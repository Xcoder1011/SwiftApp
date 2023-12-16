//
//  MVCViewController.swift
//  SwiftApp
//
//  Created by KUN on 2023/12/15.
//

import UIKit

class MVCViewController: TableViewController {
    
    private let searchController = UISearchController(searchResultsController: nil)
    private let validator = ThrottledTextFieldValidator()
    private let fetcher = CancellableReposFetcher()
    private let dataSource = MyTableViewDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "MVC"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startFetching(forQuery: "RxSwift")
    }
    
    override func makeUI() {
        super.makeUI()
        tableView.headRefreshControl = nil
        tableView.footRefreshControl = nil
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        
        searchController.searchResultsUpdater = self
        searchController.delegate = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.sizeToFit()
        self.navigationItem.titleView = searchController.searchBar
        
        tableView.dataSource = dataSource
        tableView.delegate = self
    }
    
    private func didChangeQuery(_ query: String) {
        validator.validate(query: query) { [weak self] query in
            guard let strongSelf = self,
                  let query = query else { return }
            strongSelf.startFetching(forQuery: query)
        }
    }
    
    private func startFetching(forQuery query: String) {
        fetcher.fetchRepos(withQuery: query, completion: { [weak self] repos in
            guard let strongSelf = self else { return }
            strongSelf.dataSource.repos = repos
            strongSelf.tableView.reloadData()
        })
    }
    
    private func didSelectRow(at indexPath: IndexPath) {
        guard let repos = dataSource.repos else { return }
        let id = repos[indexPath.item].id
        let alertController = UIAlertController(title: "\(id)", message: nil, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        if searchController.isActive {
            searchController.present(alertController, animated: true)
        } else {
            present(alertController, animated: true, completion: nil)
        }
    }
}

extension MVCViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectRow(at: indexPath)
    }
}

extension MVCViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        didChangeQuery(searchController.searchBar.text ?? "")
    }
}

extension MVCViewController: UISearchControllerDelegate {
    func didDismissSearchController(_ searchController: UISearchController) {
        startFetching(forQuery: "RxSwift")
    }
}
