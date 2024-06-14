//
//  TableViewController+Refresh.swift
//  SwiftApp
//
//  Created by KUN on 2024/5/24.
//

import RxCocoa
import RxSwift

protocol ScrollViewRefreshable {
    var refreshScrollView: UIScrollView { get }
    func setupRefreshConfig()
}

protocol RefreshableSubject {
    var headerRefreshTrigger: PublishSubject<Void> { get set }
    var footerRefreshTrigger: PublishSubject<Void> { get set }
}

private enum RSAssociatedKeys {
    static var headerRefreshTrigger: UInt8 = 0
    static var footerRefreshTrigger: UInt8 = 0
}

extension RefreshableSubject {
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
}
