//
//  ViewModelRefreshable.swift
//  SwiftApp
//
//  Created by KUN on 2024/5/24.
//

import Combine
import MJRefresh
import RxCocoa
import RxSwift

// MARK: - ViewModelRefreshable

protocol ViewModelRefreshable {
    /// RxSwift
    var refreshingStateObservable: BehaviorRelay<RefreshingState> { get set }
    /// Combine
    var refreshingStateSubject: PassthroughSubject<RefreshingState, Never> { get set }
}

private var refreshingStateObservableKey: UInt8 = 0
private var refreshingStateSubjectKey: UInt8 = 0

extension ViewModelRefreshable {
    /// RxSwift
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

    /// Combine
    var refreshingStateSubject: PassthroughSubject<RefreshingState, Never> {
        get {
            guard let subject = objc_getAssociatedObject(self, &refreshingStateSubjectKey) as? PassthroughSubject<RefreshingState, Never> else {
                let newSubject = PassthroughSubject<RefreshingState, Never>()
                objc_setAssociatedObject(self, &refreshingStateSubjectKey, newSubject, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return newSubject
            }
            return subject
        }
        set {
            objc_setAssociatedObject(self, &refreshingStateSubjectKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
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
