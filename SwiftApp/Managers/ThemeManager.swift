//
//  ThemeManager.swift
//  SwiftApp
//
//  Created by KUN on 2023/12/6.
//

import RxCocoa
import RxSwift

let globalStatusBarStyle = BehaviorRelay<UIStatusBarStyle>(value: .default)

enum Colors {
    static let offlineColor = UIColor(red: 1.0, green: 0.6, blue: 0.6, alpha: 1.0)
    static let onlineColor = nil as UIColor?
}
