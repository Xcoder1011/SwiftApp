//
//  NavigationController.swift
//  SwiftApp
//
//  Created by KUN on 2023/12/6.
//

import UIKit

class NavigationController: UINavigationController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        globalStatusBarStyle.value
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        interactivePopGestureRecognizer?.delegate = nil
    }
}
