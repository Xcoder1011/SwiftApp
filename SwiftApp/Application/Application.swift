//
//  Application.swift
//  SwiftApp
//
//  Created by KUN on 2023/11/30.
//

import Foundation
import UIKit

class Application: NSObject {
    static let shared = Application()
    
    var window: UIWindow?
    
    init(window: UIWindow? = nil) {
        self.window = window
    }
    
    override init() {
        super.init()
    }
    
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
