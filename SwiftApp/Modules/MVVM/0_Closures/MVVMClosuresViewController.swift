//
//  MVVMClosuresViewController.swift
//  SwiftApp
//
//  Created by KUN on 2024/1/15.
//

import UIKit

class MVVMClosuresViewController: TableViewController {
    
    private let searchController = UISearchController(searchResultsController: nil)
    private let dataSource = MyTableViewDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "MVVM + Closures"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let viewModel = viewModel as? MVVMClosuresViewModel {
            viewModel.didChangeQuery("RxSwift")
        }
    }
    
    override func makeUI() {
        super.makeUI()
        tableView.headRefreshControl = nil
        tableView.footRefreshControl = nil
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.reuseIdentifier)
        
        searchController.searchResultsUpdater = self
        searchController.delegate = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.sizeToFit()
        self.navigationItem.titleView = searchController.searchBar
        
        tableView.dataSource = dataSource
        tableView.delegate = self
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        guard let viewModel = viewModel as? MVVMClosuresViewModel else { return }
        
        viewModel.didReceiveRepos = { [weak self] repos in
            guard let strongSelf = self else { return }
            strongSelf.dataSource.repos = repos
            strongSelf.tableView.reloadData()
        }
        
        viewModel.didSelectId = { [weak self] id in
            guard let strongSelf = self else { return }
            strongSelf.showSelectId(id)
        }
        
        viewModel.requestIsLoadding = { [weak self] isLoadding in
            guard let strongSelf = self else { return }
            if isLoadding {
                strongSelf.startAnimating()
            } else {
                strongSelf.stopAnimating()
            }
        }
    }
    
    private func showSelectId(_ id: Int) {
        let alertController = UIAlertController(title: "\(id)", message: nil, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        if searchController.isActive {
            searchController.present(alertController, animated: true)
        } else {
            present(alertController, animated: true, completion: nil)
        }
    }
}

extension MVVMClosuresViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let viewModel = viewModel as? MVVMClosuresViewModel {
            viewModel.didSelectRow(at: indexPath)
        }
    }
}

extension MVVMClosuresViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let viewModel = viewModel as? MVVMClosuresViewModel {
            viewModel.didChangeQuery(searchController.searchBar.text ?? "")
        }
    }
}

extension MVVMClosuresViewController: UISearchControllerDelegate {
    func didDismissSearchController(_ searchController: UISearchController) {
        if let viewModel = viewModel as? MVVMClosuresViewModel {
            viewModel.didChangeQuery("RxSwift")
        }
    }
}
