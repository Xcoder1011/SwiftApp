//
//  RxSwiftSubjectsController.swift
//  SwiftApp
//
//  Created by KUN on 2024/1/15.
//

import UIKit

class RxSwiftSubjectsController: MVVMBaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "mvvm-rxswift-subjects-observables"
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        guard let viewModel = viewModel as? RxSwiftSubjectsViewModel else { return }
        
        rx.viewWillAppear
            .asObservable()
            .bind(to: viewModel.viewWillAppearSubject)
            .disposed(by: disposeBag)
        
        searchController.searchBar.rx.text.orEmpty
            .asObservable()
            .bind(to: viewModel.didSearchSubject)
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .asObservable()
            .bind(to: viewModel.didSelectRowSubject)
            .disposed(by: disposeBag)
        
        
        viewModel.didReceiveRepos
            .drive(tableView.rx.items(cellIdentifier: UITableViewCell.reuseIdentifier, cellType: UITableViewCell.self)) { (row, repo, cell) in
                cell.textLabel?.numberOfLines = 0
                cell.textLabel?.text = "\(repo.name)\n\(repo.description)"
            }
            .disposed(by: disposeBag)
        
        viewModel.requestIsLoadding
            .drive(onNext: { [weak self] isLoadding in
                guard let strongSelf = self else { return }
                if isLoadding {
                    strongSelf.startAnimating()
                } else {
                    strongSelf.stopAnimating()
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.didSelectId
            .drive(onNext: { [weak self] repoId in
                guard let strongSelf = self else { return }
                strongSelf.showSelectId(repoId)
            })
            .disposed(by: disposeBag)
    }
}
