//
//  MVPViewController.swift
//  SwiftApp
//
//  Created by KUN on 2023/12/16.
//

import UIKit

class MVPViewController: TableViewController {
    private let searchController = UISearchController(searchResultsController: nil)
    private let dataSource = MyTableViewDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "MVP"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let viewModel = viewModel as? MVPViewModel {
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
        navigationItem.titleView = searchController.searchBar
        
        tableView.dataSource = dataSource
        tableView.delegate = self
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        if let viewModel = viewModel as? MVPViewModel {
            viewModel.delegate = self
        }
    }
}

extension MVPViewController: MVPViewModelDelegate {
    func mvpReposViewModel(_ reposViewModel: MVPViewModel, didReceiveRepos repos: [Repo]) {
        dataSource.repos = repos
        tableView.reloadData()
    }
    
    func mvpReposViewModel(_ reposViewModel: MVPViewModel, didSelectRepoWithId id: Int) {
        let alertController = UIAlertController(title: "\(id)", message: nil, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        if let presentedVC = presentedViewController, presentedVC == searchController {
            searchController.present(alertController, animated: true)
        } else {
            present(alertController, animated: true, completion: nil)
        }
    }
    
    func mvpReposViewModel(_ reposViewModel: MVPViewModel, isRequestLoading: Bool) {
        if isRequestLoading {
            startAnimating()
        } else {
            stopAnimating()
        }
    }
}

extension MVPViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let viewModel = viewModel as? MVPViewModel {
            viewModel.didSelectRow(at: indexPath)
        }
    }
}

extension MVPViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let viewModel = viewModel as? MVPViewModel {
            viewModel.didChangeQuery(searchController.searchBar.text ?? "")
        }
    }
}

extension MVPViewController: UISearchControllerDelegate {
    func didDismissSearchController(_ searchController: UISearchController) {
        if let viewModel = viewModel as? MVPViewModel {
            viewModel.didChangeQuery("RxSwift")
        }
    }
}
