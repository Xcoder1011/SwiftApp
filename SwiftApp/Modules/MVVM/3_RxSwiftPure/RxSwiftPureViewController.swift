//
//  RxSwiftPureViewController.swift
//  SwiftApp
//
//  Created by KUN on 2024/1/15.
//

import UIKit

class RxSwiftPureViewController: MVVMBaseViewController {
   
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "mvvm-rxswift-pure"
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        let ready = rx.viewWillAppear.asDriver()
        let selectedIndex = tableView.rx.itemSelected.asDriver()
        let searchText = searchController.searchBar.rx.text.orEmpty.asDriver()
        
        let input = RxSwiftPureViewModel.Input(ready: ready,
                                               selectedIndex: selectedIndex,
                                               searchText: searchText)
        
        guard let viewModel = viewModel as? RxSwiftPureViewModel else { return }
        
        let output = viewModel.transform(input: input)
        
        output.repos
            .drive(tableView.rx
                .items(cellIdentifier: UITableViewCell.reuseIdentifier, cellType: UITableViewCell.self)) { (row, repo, cell) in
                    cell.textLabel?.numberOfLines = 0
                    cell.textLabel?.text = "\(repo.name)\n\(repo.description)"
                }
                .disposed(by: disposeBag)
        
        output.requestIsLoadding
            .drive(onNext: { [weak self] isLoadding in
                guard let strongSelf = self else { return }
                if isLoadding {
                    strongSelf.startAnimating()
                } else {
                    strongSelf.stopAnimating()
                }
            })
            .disposed(by: disposeBag)
        
        output.didSelectId
            .drive(onNext: { [weak self] repoId in
                guard let strongSelf = self else { return }
                strongSelf.showSelectId(repoId)
            })
            .disposed(by: disposeBag)
    }
}
