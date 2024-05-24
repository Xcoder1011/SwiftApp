//
//  RxSwiftGitHubSearchController.swift
//  SwiftApp
//
//  Created by KUN on 2024/5/17.
//

import UIKit
import RxSwift
import Kingfisher

class RxSwiftGitHubSearchController: TableViewController {
    override func makeUI() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.reuseIdentifier)
        super.makeUI()
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        guard let viewModel = viewModel as? RxSwiftGitHubSearchViewModel else { return }
        
//        let refresh = Observable.of(Observable.just(()), headerRefreshTrigger).merge()
        
        let input = RxSwiftGitHubSearchViewModel.Input(headerRefresh: headerRefreshTrigger, footerRefresh: footerRefreshTrigger)
        let output = viewModel.transform(input: input)
        
        output.repos
            .drive(tableView.rx
                .items(cellIdentifier: UITableViewCell.reuseIdentifier, cellType: UITableViewCell.self)) { (row, repo, cell) in
                    cell.textLabel?.numberOfLines = 0
                    cell.textLabel?.text = "\(repo.name) -- \(repo.stars)\n\(repo.url)"
                }
                .disposed(by: disposeBag)
    }
}
