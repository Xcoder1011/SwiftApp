//
//  RefreshStatusBinder.swift
//  SwiftApp
//
//  Created by KUN on 2024/5/24.
//

import UIKit
import RxSwift
import RxCocoa
import MJRefresh

enum RefreshingState {
    case idle /** 普通闲置状态 */
    case headerBeginRefreshing, headerEndRefreshing
    case footerBeginRefreshing, footerEndRefreshing
    case endRefreshingWithNoMoreData
    case resetNoMoreData
}

extension Reactive where Base: UIScrollView {
    var refreshingState: Binder<RefreshingState> {
        return Binder(self.base) { scrollView, state in
            switch state {
            case .idle:
                scrollView.mj_header?.endRefreshing()
                scrollView.mj_footer?.endRefreshing()
            case .headerBeginRefreshing:
                scrollView.mj_header?.beginRefreshing()
            case .footerBeginRefreshing:
                scrollView.mj_footer?.beginRefreshing()
            case .headerEndRefreshing:
                scrollView.mj_header?.endRefreshing()
            case .footerEndRefreshing:
                scrollView.mj_footer?.endRefreshing()
            case .endRefreshingWithNoMoreData:
                scrollView.mj_footer?.endRefreshingWithNoMoreData()
            case .resetNoMoreData:
                scrollView.mj_footer?.resetNoMoreData()
            }
        }
    }
}
