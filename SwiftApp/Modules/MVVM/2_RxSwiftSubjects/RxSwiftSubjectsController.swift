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
            .drive(tableView.rx.items(cellIdentifier: UITableViewCell.reuseIdentifier, cellType: UITableViewCell.self)) { _, repo, cell in
                cell.textLabel?.numberOfLines = 0
                cell.textLabel?.text = "\(repo.name)\n\(repo.description)"
            }
            .disposed(by: disposeBag)
        
        viewModel.requestLoading
            .drive(onNext: { [weak self] isLoading in
                guard let self else { return }
                if isLoading {
                    startAnimating()
                } else {
                    stopAnimating()
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.didSelectId
            .drive(onNext: { [weak self] repoId in
                guard let self else { return }
                showSelectId(repoId)
            })
            .disposed(by: disposeBag)
    }
}
