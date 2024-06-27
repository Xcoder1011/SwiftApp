//
//  RefreshStatusBinder.swift
//  SwiftApp
//
//  Created by KUN on 2024/5/24.
//

import MJRefresh
import RxCocoa
import RxSwift
import UIKit

enum RefreshingState {
    case idle /** 普通闲置状态 */
    case headerBeginRefreshing, headerEndRefreshing
    case footerBeginRefreshing, footerEndRefreshing
    case endRefreshingWithNoMoreData
    case resetNoMoreData
}

extension Reactive where Base: UIScrollView {
    var refreshingState: Binder<RefreshingState> {
        Binder(self.base) { scrollView, state in
            scrollView.updateRefreshingState(state)
        }
    }
}

extension UIScrollView {
    // 根据状态更新scrollView的刷新组件
    func updateRefreshingState(_ state: RefreshingState) {
        switch state {
        case .idle:
            self.mj_header?.endRefreshing()
            self.mj_footer?.endRefreshing()
        case .headerBeginRefreshing:
            self.mj_header?.beginRefreshing()
        case .footerBeginRefreshing:
            self.mj_footer?.beginRefreshing()
        case .headerEndRefreshing:
            self.mj_header?.endRefreshing()
        case .footerEndRefreshing:
            self.mj_footer?.endRefreshing()
        case .endRefreshingWithNoMoreData:
            self.mj_footer?.endRefreshingWithNoMoreData()
        case .resetNoMoreData:
            self.mj_footer?.resetNoMoreData()
        }
    }
}
