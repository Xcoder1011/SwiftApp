//
//  TableViewController.swift
//  SwiftApp
//
//  Created by KUN on 2023/12/6.
//

import UIKit
import RxSwift
import RxCocoa
import KafkaRefresh

class TableViewController: BaseViewController, UIScrollViewDelegate {
    
    let headerRefreshTrigger = PublishSubject<Void>()
    let footerRefreshTrigger = PublishSubject<Void>()

    let isHeaderLoading = BehaviorRelay(value: false)
    let isFooterLoading = BehaviorRelay(value: false)
    
    lazy var tableView: TableView = {
        let view = TableView(frame: CGRect(), style: .plain)
        view.emptyDataSetSource = self
        view.emptyDataSetDelegate = self
        view.rx.setDelegate(self).disposed(by: disposeBag)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func makeUI() {
        super.makeUI()
        
        self.contentView.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        tableView.bindGlobalStyle(forHeadRefreshHandler: { [weak self] in
            self?.headerRefreshTrigger.onNext(())
        })

        tableView.bindGlobalStyle(forFootRefreshHandler: { [weak self] in
            self?.footerRefreshTrigger.onNext(())
        })

        isHeaderLoading.bind(to: tableView.headRefreshControl.rx.isAnimating).disposed(by: disposeBag)
        isFooterLoading.bind(to: tableView.footRefreshControl.rx.isAnimating).disposed(by: disposeBag)

        tableView.footRefreshControl.autoRefreshOnFoot = true
    }
    
    override func bindViewModel() {
        viewModel?.headerLoading.asObservable().bind(to: isHeaderLoading).disposed(by: disposeBag)
        viewModel?.footerLoading.asObservable().bind(to: isFooterLoading).disposed(by: disposeBag)
        
        let updateEmptyDataSet = Observable.of(isLoading.map { _ in }.asObservable(), emptyDataSetImageTintColor.map({ _ in }), languageChanged.asObservable()).merge()
        updateEmptyDataSet.subscribe(onNext: { [weak self] () in
            self?.tableView.reloadEmptyDataSet()
        }).disposed(by: disposeBag)

    }
}


