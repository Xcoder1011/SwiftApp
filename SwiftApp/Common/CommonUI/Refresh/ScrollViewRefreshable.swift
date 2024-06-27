//
//  TableViewController+Refresh.swift
//  SwiftApp
//
//  Created by KUN on 2024/5/24.
//

import Combine
import RxCocoa
import RxSwift

protocol ScrollViewRefreshable {
    var refreshScrollView: UIScrollView { get }
    func setupRefreshConfig()
}

protocol RefreshableSubject {
    /// RxSwift
    var headerRefreshTrigger: PublishSubject<Void> { get set }
    var footerRefreshTrigger: PublishSubject<Void> { get set }

    /// Combine
    var headerRefreshCombineTrigger: PassthroughSubject<Void, Never> { get set }
    var footerRefreshCombineTrigger: PassthroughSubject<Void, Never> { get set }
}

private enum RSAssociatedKeys {
    static var headerRefreshTrigger: UInt8 = 0
    static var footerRefreshTrigger: UInt8 = 0
    static var headerRefreshCombineTrigger: UInt8 = 0
    static var footerRefreshCombineTrigger: UInt8 = 0
}

extension RefreshableSubject {
    /// RxSwift
    var headerRefreshTrigger: PublishSubject<Void> {
        get {
            guard let trigger = objc_getAssociatedObject(self, &RSAssociatedKeys.headerRefreshTrigger) as? PublishSubject<Void> else {
                let newTrigger = PublishSubject<Void>()
                objc_setAssociatedObject(self, &RSAssociatedKeys.headerRefreshTrigger, newTrigger, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return newTrigger
            }
            return trigger
        }
        set {
            objc_setAssociatedObject(self, &RSAssociatedKeys.headerRefreshTrigger, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    var footerRefreshTrigger: PublishSubject<Void> {
        get {
            guard let trigger = objc_getAssociatedObject(self, &RSAssociatedKeys.footerRefreshTrigger) as? PublishSubject<Void> else {
                let newTrigger = PublishSubject<Void>()
                objc_setAssociatedObject(self, &RSAssociatedKeys.footerRefreshTrigger, newTrigger, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return newTrigger
            }
            return trigger
        }
        set {
            objc_setAssociatedObject(self, &RSAssociatedKeys.footerRefreshTrigger, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    /// Combine
    var headerRefreshCombineTrigger: PassthroughSubject<Void, Never> {
        get {
            guard let trigger = objc_getAssociatedObject(self, &RSAssociatedKeys.headerRefreshCombineTrigger) as? PassthroughSubject<Void, Never> else {
                let newTrigger = PassthroughSubject<Void, Never>()
                objc_setAssociatedObject(self, &RSAssociatedKeys.headerRefreshCombineTrigger, newTrigger, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return newTrigger
            }
            return trigger
        }
        set {
            objc_setAssociatedObject(self, &RSAssociatedKeys.headerRefreshCombineTrigger, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    var footerRefreshCombineTrigger: PassthroughSubject<Void, Never> {
        get {
            guard let trigger = objc_getAssociatedObject(self, &RSAssociatedKeys.footerRefreshCombineTrigger) as? PassthroughSubject<Void, Never> else {
                let newTrigger = PassthroughSubject<Void, Never>()
                objc_setAssociatedObject(self, &RSAssociatedKeys.footerRefreshCombineTrigger, newTrigger, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return newTrigger
            }
            return trigger
        }
        set {
            objc_setAssociatedObject(self, &RSAssociatedKeys.footerRefreshCombineTrigger, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
