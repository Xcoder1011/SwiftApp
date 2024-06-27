//
//  CombineGitHubSearchController.swift
//  SwiftApp
//
//  Created by KUN on 2024/5/17.
//

import JXSegmentedView
import Kingfisher
import RxCocoa
import RxSwift
import UIKit
import Combine

class CombineGitHubSearchController: TableViewController {
    fileprivate let segmentSelection = PassthroughSubject<Int, Never>()
    
    private let dataSource = CombineTableViewDataSource()
    
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
        tableView.dataSource = dataSource
        tableView.delegate = self
        
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
        
        guard let viewModel = viewModel as? CombineGitHubSearchViewModel else { return }
        let input = CombineGitHubSearchViewModel.Input(headerRefresh: headerRefreshCombineTrigger,
                                                       footerRefresh: footerRefreshCombineTrigger,
                                                       selectTrendingPeriod: segmentSelection)
        let output = viewModel.transform(input: input)
        
        output.repos.sink { [weak self] repos in
            guard let self else { return }
            dataSource.repos = repos
            tableView.reloadData()
        }
        .store(in: &cancellables)
    }
}

extension CombineGitHubSearchController: JXSegmentedViewDelegate {
    func segmentedView(_ segmentedView: JXSegmentedView, didSelectedItemAt index: Int) {
        segmentSelection.send(index)
        /// 仅仅点击segmentedView时出现加载动画
        viewModel?.loading.accept(true)
    }
}

extension CombineGitHubSearchController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {}
}
