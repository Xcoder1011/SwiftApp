//
//  MVVMBaseViewController.swift
//  SwiftApp
//
//  Created by KUN on 2024/1/18.
//

import UIKit

class MVVMBaseViewController: TableViewController {
    internal let searchController = UISearchController(searchResultsController: nil)
    
    override func makeUI() {
        super.makeUI()
        tableView.headRefreshControl = nil
        tableView.footRefreshControl = nil
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.reuseIdentifier)

        searchController.searchResultsUpdater = nil
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.sizeToFit()
        self.navigationItem.titleView = searchController.searchBar
    }
        
    internal func showSelectId(_ id: Int) {
        let alertController = UIAlertController(title: "\(id)", message: nil, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        if searchController.isActive {
            searchController.present(alertController, animated: true)
        } else {
            present(alertController, animated: true, completion: nil)
        }
    }
}
