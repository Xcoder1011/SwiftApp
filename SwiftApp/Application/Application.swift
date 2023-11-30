//
//  Application.swift
//  SwiftApp
//
//  Created by KUN on 2023/11/30.
//

import Foundation
import UIKit

class Application {
    static let shared = Application()
    private init() {}
    
    var window: UIWindow?

    func initialScreenWindow(in window: UIWindow?) {
        guard let window = window else { return }
        self.window = window
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            UIView.transition(with: window, duration: 0.5, options: .transitionFlipFromLeft, animations: {
                window.rootViewController = UINavigationController(rootViewController: ViewController())
            }, completion: nil)
        }
    }
}
