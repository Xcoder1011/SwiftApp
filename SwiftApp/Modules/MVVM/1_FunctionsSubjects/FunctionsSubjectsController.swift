//
//  FunctionsSubjectsController.swift
//  SwiftApp
//
//  Created by KUN on 2024/1/15.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class FunctionsSubjectsController: MVVMBaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "mvvm-functions-subjects-observables"
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        rx.viewWillAppear
            .asObservable()
            .subscribe(onNext: { [weak self] _ in
                guard let strongSelf = self else { return }
                if let viewModel = strongSelf.viewModel as? FunctionsSubjectsViewModel {
                    viewModel.viewWillAppear()
                }
            }).disposed(by: disposeBag)
        
        searchController.searchBar.rx.text.orEmpty
            .asObservable()
            .subscribe(onNext: { [weak self] text in
                guard let strongSelf = self else { return }
                if let viewModel = strongSelf.viewModel as? FunctionsSubjectsViewModel {
                    viewModel.didSearch(text)
                }
            }).disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .asObservable()
            .subscribe(onNext: { [weak self] indexPath in
                guard let strongSelf = self else { return }
                if let viewModel = strongSelf.viewModel as? FunctionsSubjectsViewModel {
                    viewModel.didSelectRowAt(indexPath)
                }
            }).disposed(by: disposeBag)
        
        
        if let viewModel = viewModel as? FunctionsSubjectsViewModel {
            viewModel.didSelectId
                .drive(onNext: { [weak self] repoId in
                    guard let strongSelf = self else { return }
                    strongSelf.showSelectId(repoId)
                }).disposed(by: disposeBag)
            
            viewModel.requestIsLoadding
                .drive(onNext: { [weak self] isLoadding in
                    guard let strongSelf = self else { return }
                    if isLoadding {
                        strongSelf.startAnimating()
                    } else {
                        strongSelf.stopAnimating()
                    }
                }).disposed(by: disposeBag)
            
            viewModel.didReceiveRepos
                .drive(tableView.rx.items(cellIdentifier: UITableViewCell.reuseIdentifier, cellType: UITableViewCell.self)) { (row, repo, cell)
                    in
                    cell.textLabel?.numberOfLines = 0
                    cell.textLabel?.text = "\(repo.name)\n\(repo.description)"
                }
                .disposed(by: disposeBag)
        }
    }
}
