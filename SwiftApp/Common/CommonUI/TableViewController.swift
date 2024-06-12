//
//  TableViewController.swift
//  SwiftApp
//
//  Created by KUN on 2023/12/6.
//

import UIKit
import RxSwift
import RxCocoa
import MJRefresh

class TableViewController: BaseViewController, UIScrollViewDelegate, RefreshableSubject {
    
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
        self.setupRefreshConfig()
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        let updateEmptyDataSet = Observable.of(isLoading.map { _ in }.asObservable(), emptyDataSetImageTintColor.map({ _ in }), languageChanged.asObservable()).merge()
        updateEmptyDataSet.subscribe(onNext: { [weak self] () in
            self?.tableView.reloadEmptyDataSet()
        }).disposed(by: disposeBag)
    }
}

extension TableViewController: ScrollViewRefreshable {
    var refreshScrollView: UIScrollView {
        return self.tableView
    }
    func setupRefreshConfig() {
        guard let viewModel = viewModel as? ViewModelRefreshable else { return }
        viewModel.refreshingStateObservable.bind(to: refreshScrollView.rx.refreshingState).disposed(by: self.disposeBag)

        if let headerVM = viewModel as? ViewModelHeaderConfigure {
            refreshScrollView.mj_header = headerVM.header
            refreshScrollView.mj_header?.refreshingBlock = { [weak self] in
                self?.headerRefreshTrigger.onNext(())
            }
            if headerVM.enterRefreshImmediately {
                refreshScrollView.mj_header?.beginRefreshing()
            }
        }
        if let footerVM = viewModel as? ViewModelFooterConfigure {
            refreshScrollView.mj_footer = footerVM.footer
            refreshScrollView.mj_footer?.refreshingBlock = { [weak self] in
                self?.footerRefreshTrigger.onNext(())
            }
        }
    }
}
