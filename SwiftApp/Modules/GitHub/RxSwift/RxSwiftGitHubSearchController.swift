//
//  RxSwiftGitHubSearchController.swift
//  SwiftApp
//
//  Created by KUN on 2024/5/17.
//

import UIKit
import RxSwift
import Kingfisher
import JXSegmentedView

class RxSwiftGitHubSearchController: TableViewController {
    
    fileprivate let segmentSelectionSubject = BehaviorSubject<Int>(value: 0)
    
    private lazy var segmentedView: JXSegmentedView = {
        let view = JXSegmentedView()
        view.delegate = self
        view.dataSource = self.segmentedDataSource
        let indicator = JXSegmentedIndicatorLineView()
        indicator.indicatorWidth = 20
        view.indicators = [indicator]
        return view
    }()
    
    private lazy var segmentedDataSource: JXSegmentedTitleDataSource = {
        let dataSource = JXSegmentedTitleDataSource()
        dataSource.isTitleColorGradientEnabled = true
        dataSource.titles = [TrendingPeriodSegments.daily.title,
                             TrendingPeriodSegments.weekly.title,
                             TrendingPeriodSegments.monthly.title]
        return dataSource
    }()
    
    override func makeUI() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.reuseIdentifier)
        super.makeUI()
        navigationItem.title = "RxSwiftGitHub"
        contentView.addSubview(segmentedView)
        segmentedView.setBorderWidth()
        let segmentedViewHeight = 44.0
        segmentedView.snp.updateConstraints { make in
            make.left.top.right.equalTo(0)
            make.height.equalTo(segmentedViewHeight)
        }
        tableView.snp.updateConstraints { make in
            make.edges.equalTo(UIEdgeInsets(top: segmentedViewHeight, left: 0, bottom: 0, right: 0))
        }
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        guard let viewModel = viewModel as? RxSwiftGitHubSearchViewModel else { return }
        let selectTrendingPeriod = self.segmentSelectionSubject.map { index in
            var value: String
            switch index {
            case 0: value = "daily"
            case 1: value = "weekly"
            case 2: value = "monthly"
            default:
                value = "daily"
            }
            return TrendingPeriodSegments(rawValue: value)!
        }
        let input = RxSwiftGitHubSearchViewModel.Input(headerRefresh: headerRefreshTrigger,
                                                       footerRefresh: footerRefreshTrigger,
                                                       selectTrendingPeriod: selectTrendingPeriod)
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

extension RxSwiftGitHubSearchController: JXSegmentedViewDelegate {
    func segmentedView(_ segmentedView: JXSegmentedView, didSelectedItemAt index: Int) {
        self.segmentSelectionSubject.onNext(index)
    }
}
