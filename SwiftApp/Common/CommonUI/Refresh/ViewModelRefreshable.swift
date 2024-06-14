//
//  ViewModelRefreshable.swift
//  SwiftApp
//
//  Created by KUN on 2024/5/24.
//

import MJRefresh
import RxCocoa
import RxSwift

// MARK: - ViewModelRefreshable

protocol ViewModelRefreshable {
    var refreshingStateObservable: BehaviorRelay<RefreshingState> { get set }
}

private var refreshingStateObservableKey: UInt8 = 0

extension ViewModelRefreshable {
    var refreshingStateObservable: BehaviorRelay<RefreshingState> {
        get {
            guard let observable = objc_getAssociatedObject(self, &refreshingStateObservableKey) as? BehaviorRelay<RefreshingState> else {
                let newObservable = BehaviorRelay<RefreshingState>(value: .idle)
                objc_setAssociatedObject(self, &refreshingStateObservableKey, newObservable, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return newObservable
            }
            return observable
        }
        set {
            objc_setAssociatedObject(self, &refreshingStateObservableKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

typealias ViewModelHeaderFooterConfigure = ViewModelFooterConfigure & ViewModelHeaderConfigure

// MARK: - ViewModelHeaderConfigure

protocol ViewModelHeaderConfigure: ViewModelRefreshable {
    /// 下拉刷新
    var header: MJRefreshHeader { get }
    /// 进入立即刷新
    var enterRefreshImmediately: Bool { get }
}

extension ViewModelHeaderConfigure {
    var header: MJRefreshHeader {
        MJRefreshNormalHeader()
    }

    var enterRefreshImmediately: Bool {
        false
    }
}

// MARK: - ViewModelFooterConfigure

protocol ViewModelFooterConfigure: ViewModelRefreshable {
    /// 上拉加载
    var footer: MJRefreshFooter { get }
}

extension ViewModelFooterConfigure {
    var footer: MJRefreshFooter {
        MJRefreshAutoNormalFooter()
    }
}
