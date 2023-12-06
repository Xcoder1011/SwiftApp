//
//  NavigationController.swift
//  SwiftApp
//
//  Created by KUN on 2023/12/6.
//

import UIKit
import RxSwift
import RxCocoa

let globalStatusBarStyle = BehaviorRelay<UIStatusBarStyle>(value: .default)

class NavigationController: UINavigationController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return globalStatusBarStyle.value
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        interactivePopGestureRecognizer?.delegate = nil
    }
}
