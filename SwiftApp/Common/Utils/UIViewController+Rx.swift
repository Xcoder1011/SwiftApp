//
//  UIViewController+Rx.swift
//  SwiftApp
//
//  Created by KUN on 2024/1/17.
//

import Foundation
import RxCocoa
import RxSwift

extension Reactive where Base: UIViewController {
    var viewWillAppear: ControlEvent<Void> {
        let source = self.methodInvoked(#selector(Base.viewWillAppear(_:))).map { _ in }
        return ControlEvent(events: source)
    }
}
